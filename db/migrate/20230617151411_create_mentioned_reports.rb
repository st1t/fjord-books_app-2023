class CreateMentionedReports < ActiveRecord::Migration[7.0]
  def change
    create_table :mentioned_reports do |t|
      t.references :report, null: false, foreign_key: true
      t.references :mentioned_report, null: false, foreign_key: { to_table: :reports }, class_name: "Report"

      t.timestamps
    end
  end
end
