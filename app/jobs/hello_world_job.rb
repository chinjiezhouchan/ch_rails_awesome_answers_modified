# To generate the table for "delayed_job"'s queue, run:
# rails g delayed_job:active_record

# To generate a job file, run:
# rails g job <job-name>

# Use jobs to run code when:
# - The code takes long to time to execute (e.g. seconds to days)
# e.g. You want to run code at scheduled times or intervals (e.g
#   next day, every wednesday, in 20 minutes, etc.)

class HelloWorldJob < ApplicationJob
  queue_as :default

  # When a job is executed, the "perform" will be called.
  # Usually you don't pass `perform` complex arguments. Instead something like the id to  
  
  def perform(word)
    puts "------------"
    puts "Running a job"
    puts " The word is: #{word}"
    puts "------------"
    # Do something later
  end

  # To run jobs use any of the following methods:

  # <JobClass>.perform_now(<args>)
  # This will run the job synchronously and immediately. You usually
  # don't want to run a job this way, but it can useful when testing
  # in the console.

  # <JobClass>.perform_later(<args>)
  # Thsi will put job in the queue table to be run as soon as a worker is available. This will run asynchronously and it will be executed by a worker.

  # A worker is a Ruby program that will keep looking at the event queue for jobs it can run.

  # The "wait" named argument takes an interval of time.
  # HelloWorldJob.set(wait: 10.minutes).perform_later
  # The above will run the job "HelloWorldJob" once 10 minutes
  # have elapsed after "perform_later" method has been.

  # The "run_at" argument takes a date.
  # HelloWorldJob.set(run_at: 1.week.from_now)
  
  # Possible to set it recursively so it happens regularly.

 # To use arguments with a job, pass them as arguments to
  # the `perform_now` or `perform_later` methods.

  # HelloWorldJob.perform_later("My Arg")
  # HelloWorldJob.set(wait: 4.seconds).perform_later("Another one")
  # DoAllTheThingsJob.perform_now("This", "That", [1, 2, 3])

  #  To read more about ActiveJob:
  #  http://guides.rubyonrails.org/active_job_basics.html
end
