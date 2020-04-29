require_relative "../base"

require Vagrant.source_root.join("plugins/providers/virtualbox/cap/storage_controller")

describe VagrantPlugins::ProviderVirtualBox::Cap::StorageController do
  include_context "unit"

  # not "immutable objects"
  let(:subject) { VagrantPlugins::ProviderVirtualBox::Cap::StorageController.new }

  it "exists" do
    expect(subject).to exist
  end

  describe "#finalize!" do
    it "sets the type to PIIX4 if unset" do
      subject.finalize!
      expect(subject.type).to eq(:PIIX4)
    end

    it "sets the name to 'IDE Controller' if unset" do
      subject.finalize!
      expect(subject.name).to eq("IDE Controller")
    end
  end

  describe "#validate" do
    it "raises an error if the controller type is wack" do
      subject.type = :wack
      subject.finalize!
      expect { subject.validate }.to raise_error(InvalidStorageControllerTypeError)
    end
  end

  describe "#name" do
    it "defaults to 'IDE Controller'" do
      subject.finalize!
      expect(subject.name).to eq("IDE Controller")
    end
  end

  describe "#type" do
    it "defaults to PIIX4" do
      subject.finalize!
      expect(subject.type).to eq(:PIIX4)
    end
  end
end
