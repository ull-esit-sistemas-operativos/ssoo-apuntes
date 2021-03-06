require 'rake/clean'
require_relative '../task_helpers/project.rb'

CLOBBER.include(FileList[File.join(Project::OUTPUT_DIRECTORY, "*")])