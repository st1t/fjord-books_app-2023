class CreateReportMentioningReports < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentioning_reports do |t|
      t.references :report, null: false, foreign_key: true
      t.references :mentioning_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
