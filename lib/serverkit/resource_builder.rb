require "active_support/core_ext/string/inflections"
require "serverkit/resources/file"
require "serverkit/resources/git"
require "serverkit/resources/homebrew_cask"
require "serverkit/resources/homebrew"
require "serverkit/resources/recipe"
require "serverkit/resources/service"
require "serverkit/resources/symlink"
require "serverkit/resources/unknown"

module Serverkit
  class ResourceBuilder
    # @param [Serverkit::Recipe] recipe
    # @param [Hash] attributes
    def initialize(recipe, attributes)
      @attributes = attributes
      @recipe = recipe
    end

    # @return [Serverkit::Resources::Base]
    def build
      resource_class.new(@recipe, @attributes)
    end

    private

    def has_known_type?
      Resources.constants.map(&:to_s).include?(resource_class_name)
    end

    # @return [Class]
    def resource_class
      if has_known_type?
        Resources.const_get(resource_class_name, false)
      else
        Resources::Unknown
      end
    end

    # @return [String] (e.g. "File", "Symlink")
    def resource_class_name
      type.camelize
    end

    # @note Expected to return String in normal case
    # @return [Object] (e.g. "file", "symlink")
    def type
      @attributes["type"]
    end
  end
end
