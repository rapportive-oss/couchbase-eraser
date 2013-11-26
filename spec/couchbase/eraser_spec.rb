require 'couchbase/eraser'

describe Couchbase::Eraser do
  before do
    @couchbase = double 'couchbase',
                        :get => nil,
                        :set => nil,
                        :incr => nil,
                        :delete => nil
    @eraser = Couchbase::Eraser.new @couchbase
  end

  it 'should wrap a Couchbase client' do
    expect { Couchbase::Eraser.new @couchbase }.not_to raise_error
  end

  it 'should pass through GET' do
    @couchbase.should_receive(:get).with(:hello).and_return 'world'
    @eraser.get(:hello).should == 'world'
  end

  it 'should pass through INCR' do
    @couchbase.should_receive(:incr).with(:hello).and_return 1
    @eraser.incr(:hello).should == 1
  end

  it 'should pass through SET' do
    @couchbase.should_receive(:set).with(:hello, 'world')
    expect { @eraser.set(:hello, 'world') }.not_to raise_error
  end

  it 'should pass through DELETE' do
    @couchbase.should_receive(:delete).with(:hello)
    expect { @eraser.delete(:hello) }.not_to raise_error
  end

  describe '#erase_written_keys' do
    it 'should not delete anything if nothing was written' do
      @couchbase.should_not_receive :delete
      @eraser.erase_written_keys
    end

    it 'should delete a key that it set' do
      @eraser.set :hello, 'world'

      @couchbase.should_receive(:delete).with(:hello, :quiet => true)
      @eraser.erase_written_keys
    end

    it 'should delete all keys that were set' do
      @eraser.set :hello, 'world'
      @eraser.set :squiggle, 'bleep'
      @eraser.set :herp, 'derp'

      @couchbase.should_receive(:delete).at_least(3).times
      @eraser.erase_written_keys
    end

    it 'should only delete the key once even if it was set twice' do
      @eraser.set :hello, 'world'
      @eraser.set :hello, 'universe'

      @couchbase.should_receive(:delete).exactly(1).times
      @eraser.erase_written_keys
    end

    it 'should delete keys created via increment' do
      @eraser.incr :hello, :create => true
      @eraser.incr :hello

      @couchbase.should_receive(:delete).exactly(1).times
      @eraser.erase_written_keys
    end

    it 'should delete keys created normally then incremented' do
      @eraser.set :hello, 0
      @eraser.incr :hello

      @couchbase.should_receive(:delete).exactly(1).times
      @eraser.erase_written_keys
    end
  end
end
