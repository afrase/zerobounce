# frozen_string_literal: true

require 'yard'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'zerobounce/version'

RSpec::Core::RakeTask.new

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rspec'
end

YARD::Rake::YardocTask.new do |task|
  task.options += ['--title', "Zerobounce #{Zerobounce::VERSION} Documentation"]
  task.options += ['--protected']
  task.options += ['--no-private']
  task.stats_options = ['--list-undoc']

  # has to be last
  extra_files = %w[CODE_OF_CONDUCT.md LICENSE.txt]
  task.options += ['-'] + extra_files
end

task default: %i[rubocop spec]
