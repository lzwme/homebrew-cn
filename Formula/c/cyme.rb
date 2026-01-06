class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://ghfast.top/https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "fd6ac39ef39210b6875fe63a51c37a50b1a801c87b988051f1f74fd1312d7264"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6364c8f872d2e9393a75aec456b8f6fc30dc4f9a1300dc47200d15256374ba03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c706605a931d459eb142dae1952c589b7237e8f27075089aea14b95b6c08f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8f1bc62925083a40d899a5758fb58ba05c963c0402eb6f8af20a8488f18ee74"
    sha256 cellar: :any_skip_relocation, sonoma:        "02473019cd82757aa53da0408beee33ed10ad59e238063606af426b0948f4fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c4fcecfb9df9aff695166153ad94d8c10036f6263f4828655d101ceae55151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b01fb028bb756ef882ad578d944b937d5505aaef4b0b09b4553ce25059a51b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "umockdev" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_includes output, "buses"

    if OS.linux?
      # Mock USB devices using example from umockdev
      resource "usbkbd.umockdev" do
        url "https://ghfast.top/https://raw.githubusercontent.com/martinpitt/umockdev/1b58d24fb78e8297f2b0e96abb99fcbee7f37784/devices/input/usbkbd.umockdev"
        sha256 "cc7d5b277531630dbe7d93a74d24ff13f7740c5f96f6933b3ba8d1db54e25b7a"
      end
      resource("usbkbd.umockdev").stage(testpath)

      umockdev_run = "#{Formula["umockdev"].bin}/umockdev-run --device usbkbd.umockdev"
      assert_equal <<~EOS, shell_output("#{umockdev_run} -- #{bin}/cyme --no-padding --tree")
        ● 1-0 EHCI Host Controller Linux 3.10.0-2-generic ehci_hcd -
        └──○    1   2 0x8087 0x0020 Integrated Rate Matching Hub - usb
           └──○    5   4 0x17ef 0x1005 ThinkPad X200 Ultrabase (42X4963 ) - usb
              └──○    4   7 0x05f3 0x0081 Kinesis Keyboard Hub - usb
                 └──○    2   9 0x05f3 0x0007 Kinesis Advantage PRO MPC/USB Keyboard - usb
      EOS
    else
      assert_predicate output["buses"], :present?
    end
  end
end