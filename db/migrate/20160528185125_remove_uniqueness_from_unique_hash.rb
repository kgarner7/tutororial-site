class RemoveUniquenessFromUniqueHash < ActiveRecord::Migration
  def change
    remove_index :answers, :unique_hash
  end
end
