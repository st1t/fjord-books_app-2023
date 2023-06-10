class ChangeColumnTypeInComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
    add_reference :comments, :commentable, polymorphic: true, null: false, index: true
  end
end
