class AddUniqueIndexToMentionerReportId < ActiveRecord::Migration[7.0]
  def change
    add_index :mentioned_reports, [:mentioner_report_id, :mentionee_report_id], unique: true, name: 'index_mentioned_reports_on_mentioner_mentionee'
  end
end
