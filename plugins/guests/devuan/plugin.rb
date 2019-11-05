require "vagrant"

module VagrantPlugins
  module GuestDevuan
    class Plugin < Vagrant.plugin("2")
      name "Devuan guest"
      description "Devuan guest support."

      guest(:devuan, :debian) do
        require_relative "guest"
        Guest
      end
    end
  end
end
