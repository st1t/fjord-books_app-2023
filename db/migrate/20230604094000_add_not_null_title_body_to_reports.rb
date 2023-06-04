class AddNotNullTitleBodyToReports < ActiveRecord::Migration[7.0]
  def change
    change_column :reports, :title, :string, null: false
    change_column :reports, :body, :string, null: false
  end
end
