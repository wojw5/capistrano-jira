module Capistrano
  module Jira
    module Finder
      extend ActiveSupport::Concern

      included do
        attr_reader :items

        def find!
          return unless self.class.finder_block
          @items = self.class.finder_block.call
        end

        def find
          return unless self.class.finder_block
          @items ||= self.class.finder_block.call
        end
      end

      class_methods do
        attr_reader :finder_block

        def execute(&block)
          return unless block_given?
          @finder_block = block
        end
      end
    end
  end
end
