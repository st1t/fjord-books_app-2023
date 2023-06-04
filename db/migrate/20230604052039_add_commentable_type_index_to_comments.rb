class AddCommentableTypeIndexToComments < ActiveRecord::Migration[7.0]
  def change
    add_index :comments, :commentable_type
    change_column :comments, :commentable_type, :string, null: false
  end
end
