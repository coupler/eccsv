require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/test*.rb'
end
task :test => :racc
task :default => :test

desc "Compile racc grammar"
task :racc => "lib/eccsv/parser.rb"

file "lib/eccsv/parser.rb" => "lib/eccsv/parser.y" do |t|
  system("racc -g -v -o #{t.name} #{t.source}")
end
