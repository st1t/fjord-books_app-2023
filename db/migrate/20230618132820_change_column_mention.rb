class ChangeColumnMention < ActiveRecord::Migration[7.0]
  def change
    rename_column :mentioning_reports, :report_id, :mentioner_report_id
    rename_column :mentioning_reports, :mentioning_report_id, :mentionee_report_id

    rename_column :mentioned_reports, :report_id, :mentioner_report_id
    rename_column :mentioned_reports, :mentioned_report_id, :mentionee_report_id
  end
end
