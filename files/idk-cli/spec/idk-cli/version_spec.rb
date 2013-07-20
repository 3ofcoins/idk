require 'spec_helper'

# A smoke test spec to make sure tests actually work

module IdkCli
  describe VERSION do
    it 'is equal to itself' do
      expect { VERSION == IdkCli::VERSION }
    end
  end
end
