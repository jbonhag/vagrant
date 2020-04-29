module VagrantPlugins
  module ProviderVirtualBox
    module Cap
      class StorageController
        attr_accessor :name
        attr_accessor :type

        def valid_types
          [:PIIX4, :IntelAhci]
        end

        def initalize
          @name = nil
          @type = nil
        end

        def finalize!
          @name = "IDE Controller" if @name == nil
          @type = :PIIX4 if @type == nil
        end

        def exists?
          true
        end

        def validate
          raise InvalidStorageControllerTypeError if !valid_types.include?(@type)
        end
      end
    end
  end
end

class InvalidStorageControllerTypeError < RuntimeError
end
