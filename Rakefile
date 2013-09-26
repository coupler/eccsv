require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/test*.rb'
end
task :test => :treetop
task :default => :test

desc "Compile treetop grammar"
task :treetop => "lib/csv_parser/csv_parser.rb"

file "lib/csv_parser/csv_parser.rb" => "lib/csv_parser.treetop" do
  system("tt lib/csv_parser.treetop -o lib/csv_parser/csv_parser.rb")
end
