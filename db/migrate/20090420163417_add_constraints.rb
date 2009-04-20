class AddConstraints < ActiveRecord::Migration
  def self.add_constraint src_table, src_column, dst_table, dst_column
    execute(<<-eosql)
      ALTER TABLE #{src_table}
      ADD CONSTRAINT #{src_table}_#{src_column}_fkey FOREIGN KEY
      (#{src_column}) REFERENCES #{dst_table} (#{dst_column});
    eosql
  end

  def self.drop_constraint src_table, src_column
    execute(<<-eosql)
      ALTER TABLE #{src_table}
      DROP CONSTRAINT #{src_table}_#{src_column}_fkey
    eosql
  end

  def self.up
    add_constraint(:authors_ruby_gems, :author_id, :authors, :id)
    add_constraint(:authors_ruby_gems, :ruby_gem_id, :ruby_gems, :id)
    add_constraint(:releases, :ruby_gem_id, :ruby_gems, :id)
  end

  def self.down
    drop_constraint(:authors_ruby_gems, :author_id)
    drop_constraint(:authors_ruby_gems, :ruby_gem_id)
    drop_constraint(:releases, :ruby_gem_id)
  end
end
