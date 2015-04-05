require "digest"
require "serverkit/resources/base"

module Serverkit
  module Resources
    class File < Base
      attribute :destination, required: true, type: String
      attribute :group, type: String
      attribute :owner, type: String
      attribute :source, readable: true, required: true, type: String

      def apply
        send_file if file_sendable?
        change_group unless has_valid_group?
        change_owner unless has_valid_owner?
      end

      # @return [true, false]
      def diff
        has_file? && has_same_content? && has_valid_group? && has_valid_owner?
      end

      private

      def change_group
        run_command_from_identifier(:change_file_group, destination, group)
      end

      def change_owner
        run_command_from_identifier(:change_file_owner, destination, owner)
      end

      def file_sendable?
        !has_file? || !has_same_content?
      end

      def has_file?
        check_command_from_identifier(:check_file_is_file, destination)
      end

      def has_same_content?
        remote_file_sha256sum == local_file_sha256sum
      end

      def has_valid_group?
        group.nil? || check_command_from_identifier(:check_file_is_grouped, destination, group)
      end

      def has_valid_owner?
        owner.nil? || check_command_from_identifier(:check_file_is_owned_by, destination, owner)
      end

      # @return [String]
      def local_file_sha256sum
        ::Digest::SHA256.hexdigest(::File.read(source))
      end

      # @return [String]
      def remote_file_sha256sum
        run_command_from_identifier(:get_file_sha256sum, destination).stdout.rstrip
      end

      def send_file
        run_command_from_identifier(:send_file, source, destination)
      end
    end
  end
end
