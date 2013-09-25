Overview
--------

CouchbaseEraser wraps the
[Couchbase](http://rubydoc.info/gems/couchbase/latest/frames) client, tracks
every write you perform, and provides a method to delete every key that you
wrote to.

This is useful for testing, where you want to avoid your tests interfering with
each other by leaving data around in Couchbase.

Usage
-----

In your `spec/spec_helper.rb` or similar, assuming you have a class
`WidgetCache` with a class method `WidgetCache.couchbase` which returns the
Couchbase client:

```ruby
require 'couchbase/eraser'

class << WidgetCache
  def couchbase_with_erasure
    couchbase_eraser
  end

  def couchbase_eraser
    @couchbase_eraser ||= Couchbase::Eraser.new(couchbase_without_erasure)
  end

  alias_method_chain :couchbase, :erasure
end

RSpec.configure do |config|
  config.after(:each) do
    WidgetCache.couchbase_eraser.erase_written_keys
  end
end
```

Limitations
-----------

For now the only supported operations are GET, SET and DELETE, although it
shouldn't be hard to support more methods.  (For an operation which
straightforwardly reads from or writes to a single key, it's a one-line change
to add support for it.  Operations with more complicated semantics, such as
map-reduce, will be harder to support.)
