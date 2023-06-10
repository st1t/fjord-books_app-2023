class AddIdTypeCompositIndexToComments < ActiveRecord::Migration[7.0]
  def change
    remove_index :comments, column: :commentable_type
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
