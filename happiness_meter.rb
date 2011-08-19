require 'trollop'
require 'pstore'

require File.expand_path('../bundle_of_happiness.rb', __FILE__)

opts = Trollop::options do
  version 'happiness-meter 1.0.0 by Siddarth Chandrasekaran (2011)'
  banner <<-EOS
The happiness meter is used to track your happiness over time.

Usage:
       ./happiness-meter [options] <filenames>+
where [options] are:
EOS

  opt :list, 'List all values to date.'
  opt :add, 'Add a data point.', :type => Float
  opt :note, 'Add a note while adding a data point.', :type => String
end

# some janky sanitization.
if (opts[:list] == true)
  Trollop::die 'Cannot list AND add.' if !opts[:add].nil?
  Trollop::die :note, 'can be used only when adding data points.' if !opts[:note].nil?
elsif (!opts[:add].nil?)
  Trollop::die :add, 'must be non-negative' if opts[:add] < 0 unless (opts[:list] == true)
else
  Trollop::die 'Please enter an option.' if opts[:add].nil? && (opts[:list] == false)
end

happiness_vault = PStore.new('happiness.pstore')

if (opts[:list] == true)
  happiness_vault.transaction(true) do
    if (happiness_vault[:values].nil?)
      puts 'No data points available.'
    else
      happiness_vault[:values].each do |bundle|
        p bundle
      end
    end
  end
else
  opts[:note] ||= 'None.'
  bundle = BundleOfHappiness.new(opts[:add], opts[:note])
  puts "Adding new data point: %s" % bundle

  happiness_vault.transaction do
    happiness_vault[:values] ||= Array.new
    happiness_vault[:values].push(bundle)
  end
end

