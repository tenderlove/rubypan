desc "Creates Postgres fulltext indexes"
task :search_index => [:environment] do
  Dir[File.join(RAILS_ROOT, 'app', 'models', '*.rb')].each do |f|
    klass = File.basename(f, '.rb').classify.constantize
    if klass.respond_to?(:full_text_indexes)
      klass.full_text_indexes.each do |ti|
        ti.create
      end
    end
  end
end
