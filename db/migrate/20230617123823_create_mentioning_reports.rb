class CreateMentioningReports < ActiveRecord::Migration[7.0]
  def change
    create_table :mentioning_reports do |t|
      t.references :report, null: false, foreign_key: true
      t.references :mentioning_report, null: false, foreign_key: { to_table: :reports }, class_name: "Report"

      t.timestamps
    end
  end
end
