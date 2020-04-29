require File.expand_path("../../../../base", __FILE__)

require Vagrant.source_root.join("plugins/kernel_v2/config/disk")

describe VagrantPlugins::Kernel_V2::VagrantConfigDisk do
  include_context "unit"

  let(:type) { :disk }

  subject { described_class.new(type) }

  let(:provider) { double("provider") }
  let(:machine) { double("machine", provider: provider, name: "default") }

  def assert_invalid
    errors = subject.validate(machine)
    if errors.empty?
      raise "No errors: #{errors.inspect}"
    end
  end

  def assert_valid
    errors = subject.validate(machine)
    if !errors.empty?
      raise "Errors: #{errors.inspect}"
    end
  end

  before do
    env = double("env")

    subject.name = "foo"
    subject.size = 100
    allow(provider).to receive(:capability?).with(:validate_disk_ext).and_return(true)
    allow(provider).to receive(:capability).with(:validate_disk_ext, "vdi").and_return(true)
  end

  describe "with defaults" do
    it "is valid with test defaults" do
      subject.finalize!
      assert_valid
    end

    it "sets a disk type" do
      subject.finalize!
      expect(subject.type).to eq(type)
    end

    it "defaults to non-primary disk" do
      subject.finalize!
      expect(subject.primary).to eq(false)
    end
  end

  describe "defining a new config that needs to match internal restraints" do
    before do
    end
  end

  describe "config for dvd type" do
    let(:iso_path) { "/tmp/untitled.iso" }

    before do
      subject.type = :dvd
      subject.name = "untitled"
    end

    it "is valid with file path set" do
      allow(File).to receive(:file?).with(iso_path).and_return(true)
      subject.file = iso_path
      subject.finalize!
      assert_valid
    end

    it "is invalid if file path is unset" do
      subject.finalize!
      errors = subject.validate(machine)
      assert_invalid
    end
  end
end
