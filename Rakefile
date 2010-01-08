require 'spec/rake/spectask'
task :default => :spec

desc "Runs rspec tests suite"
task :spec do
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ["--color", "--format", "specdoc"]
  end
end
