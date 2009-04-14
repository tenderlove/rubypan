class ActiveRecord::Base
  class PostgresFullTextSearchIndex
    def initialize name, model_class, &block
      @name           = name
      @model_class    = model_class
      @index_columns  = {}
      @string         = nil
      instance_eval(&block)
    end

    def create
      @model_class.connection.execute(<<-eosql)
        CREATE index #{@name}
        ON #{@model_class.table_name}
        USING gin((#{to_s}))
      eosql
    end

    def method_missing name, *args
      weight = args.shift || :none
      column = name.to_s.sub(/_$/, '')
      (@index_columns[weight] ||= []) << column
    end

    def to_s
      return @string if @string
      vectors = []
      no_weight = (@index_columns[:none] || []).join(", ")
      vectors = (@index_columns.keys - [:none]).map { |weight|
        columns = @index_columns[weight].join(', ')
        "setweight(to_tsvector('english', #{columns}), '#{weight}')"
      }
      if @index_columns[:none]
        columns = @index_columns[:none].join(', ')
        vectors << "to_tsvector('english', #{columns})"
      end
      @string = vectors.join(" || ' ' || ")
    end
  end

  def self.index name = nil, &block
    class << self
      attr_accessor :full_text_indexes
    end
    self.class_eval(<<-eoruby)
      named_scope :search, lambda { |term|
        {
          :select => "*, ts_rank_cd((\#{full_text_indexes.first.to_s}),
            plainto_tsquery(\#{connection.quote(term)\})) as rank",
          :conditions =>
            ["\#{full_text_indexes.first.to_s} @@ plainto_tsquery(?)", term],
          :order => 'rank DESC'
        }
      }
    eoruby
    self.full_text_indexes ||= []
    name ||= "#{table_name}_ft_idx"
    self.full_text_indexes <<
      PostgresFullTextSearchIndex.new(name, self, &block)
  end
end

class Release < ActiveRecord::Base
  belongs_to :ruby_gem

  index do
    name        'A'
    summary     'B'
    description 'C'
  end

  named_scope :latest, lambda {
    { :conditions => ['latest = true'] }
  }
end
