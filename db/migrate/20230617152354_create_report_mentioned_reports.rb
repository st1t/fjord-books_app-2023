class CreateReportMentionedReports < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentioned_reports do |t|
      t.references :report, null: false, foreign_key: true
      t.references :mentioned_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
