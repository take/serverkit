require "serverkit/resources/base"

module Serverkit
  module Resources
    class Symlink < Base
      def apply
        run_command_from_identifier(:link_file_to, source, destination)
      end

      # @return [true, false]
      def check
        check_command_from_identifier(:check_file_is_linked_to, source, destination)
      end

      private

      # @return [String]
      def destination
        @attributes["destination"]
      end

      # @return [String]
      def source
        @attributes["source"]
      end
    end
  end
end
