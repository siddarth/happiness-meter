require 'pstore'
require File.expand_path('../bundle_of_happiness.rb', __FILE__)

class HappinessVault

  def initialize
    # initialize vault
    @happiness_vault = PStore.new('happiness.pstore')

    # initialize bundles
    @happiness_vault.transaction(true) do
      @bundles = @happiness_vault[:values]
    end
  end

  def list_all
    if (@bundles.nil?)
      puts 'No data points available.'
    else
      @bundles.each do |bundle|
        puts bundle.to_s
      end
    end
  end

  def add(value, note)
    note ||= 'None.'
    bundle = BundleOfHappiness.new(value, note)
    puts "Adding new data point: %s" % bundle

    @happiness_vault.transaction do
      @happiness_vault[:values] ||= Array.new
      @happiness_vault[:values].push(bundle)
    end
  end

  def delete_last()
    @happiness_vault.transaction do
      new_bundles = @bundles[0..-2]
      @happiness_vault[:values] = new_bundles
    end
  end
end