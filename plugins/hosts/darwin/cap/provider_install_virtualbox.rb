require "pathname"
require "tempfile"

require "vagrant/util/downloader"
require "vagrant/util/file_checksum"
require "vagrant/util/subprocess"

module VagrantPlugins
  module HostDarwin
    module Cap
      class ProviderInstallVirtualBox
        # The URL to download VirtualBox is hardcoded so we can have a
        # known-good version to download.
        URL = "https://download.virtualbox.org/virtualbox/6.1.8/VirtualBox-6.1.8-137981-OSX.dmg".freeze
        VERSION = "6.1.8".freeze
        SHA256SUM = "569e91eb3c7cb002d407b236a7aa71ac610cf2ad1afa03730dab11fbd4b89e7c".freeze

        def self.provider_install_virtualbox(env)
          path = Dir::Tmpname.create("vagrant-provider-install-virtualbox") {}

          # Prefixed UI for prettiness
          ui = Vagrant::UI::Prefixed.new(env.ui, "")

          # Start by downloading the file using the standard mechanism
          ui.output(I18n.t(
            "vagrant.hosts.darwin.virtualbox_install_download",
            version: VERSION))
          ui.detail(I18n.t(
            "vagrant.hosts.darwin.virtualbox_install_detail"))
          dl = Vagrant::Util::Downloader.new(URL, path, ui: ui)
          dl.download!

          # Validate that the file checksum matches
          actual = FileChecksum.new(path, Digest::SHA2).checksum
          if actual != SHA256SUM
            raise Vagrant::Errors::ProviderChecksumMismatch,
              provider: "virtualbox",
              actual: actual,
              expected: SHA256SUM
          end

          # Launch it
          ui.output(I18n.t(
            "vagrant.hosts.darwin.virtualbox_install_install"))
          ui.detail(I18n.t(
            "vagrant.hosts.darwin.virtualbox_install_install_detail"))
          script = File.expand_path("../../scripts/install_virtualbox.sh", __FILE__)
          result = Vagrant::Util::Subprocess.execute("bash", script, path)
          if result.exit_code != 0
            raise Vagrant::Errors::ProviderInstallFailed,
              provider: "virtualbox",
              stdout: result.stdout,
              stderr: result.stderr
          end

          ui.success(I18n.t("vagrant.hosts.darwin.virtualbox_install_success"))
        end
      end
    end
  end
end
