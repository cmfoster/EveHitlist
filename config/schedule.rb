# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -i -c ':job'"

every 2.minutes do 
  runner "EveApiChecker.check_corp_journal_for_new_donations"
  # runner "WantedToon.create!(:name => 'TEST'')"
end

every 8.hours do 
  runner "WantedToon.active_bounties.each{|target| PullWantedTargetRecord.find_new_bc_records(target)}"
end
