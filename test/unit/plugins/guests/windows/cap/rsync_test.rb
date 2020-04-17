require_relative "../../../../base"

require Vagrant.source_root.join("plugins/guests/windows/cap/rsync")

describe "VagrantPlugins::GuestWindows::Cap::RSync" do
  let(:described_class) do
    VagrantPlugins::GuestWindows::Plugin.components.guest_capabilities[:windows].get(:rsync_pre)
  end
  let(:machine) { double("machine") }
  let(:communicator) { VagrantTests::DummyCommunicator::Communicator.new(machine) }

  before do
    allow(machine).to receive(:communicate).and_return(communicator)
    allow(machine).to receive_message_chain(:config, :vm, :communicator)
  end

  after do
    communicator.verify_expectations!
  end

  describe ".rsync_pre" do
    it 'makes the guestpath directory with mkdir' do
      communicator.expect_command("mkdir -p '/sync_dir'")
      described_class.rsync_pre(machine, guestpath: '/sync_dir')
    end

    context "when using winssh communicator" do
      before do
        allow(machine).to receive_message_chain(:config, :vm, :communicator).and_return(:winssh)
      end

      it "creates the directory using the standard Windows path" do
        communicator.expect_command("md -Force 'c:\/sync_dir'")
        described_class.rsync_pre(machine, guestpath: "/cygdrive/c/sync_dir")
      end
    end
  end
end
