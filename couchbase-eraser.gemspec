Gem::Specification.new do |gem|
  gem.name = 'couchbase-eraser'
  gem.version = '0.1.0'

  gem.summary = "Wrapper for Couchbase client that deletes your data when you're done with it"
  gem.description = <<-DESC
CouchbaseEraser wraps the Couchbase client, tracks every write you perform, and provides a method to delete every key that you wrote to.

This is useful for testing, where you want to avoid your tests interfering with each other by leaving data around in Couchbase.
  DESC

  gem.authors = ['Sam Stokes']
  gem.email = %w(sstokes@linkedin.com)
  gem.homepage = 'https://github.com/rapportive-oss/couchbase-eraser'

  gem.license = 'MIT'


  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'


  gem.files = Dir[*%w(
      lib/**/*
      LICENSE*
      README*)] & %x{git ls-files -z}.split("\0")
end
