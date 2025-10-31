class Kibi < Formula
  desc "Text editor in ≤1024 lines of code, written in Rust"
  homepage "https://github.com/ilai-deutel/kibi"
  url "https://ghfast.top/https://github.com/ilai-deutel/kibi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "086eeb4c9ffaae98c02c39d932796987590978b5907ed3e6ac5d44aeabec176c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e76e6df862127bf46a1a67f49efc39e41c7cf92b0aa157186b4ea9f41f471150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6ee8ce13a3c3ecddf4028503f45b11d0ebecec4295e7b2755c199d0f4c55482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd481b2b2dbd74d128ae191297e35177cb8051b69248b7922b254b64b5d1ec64"
    sha256 cellar: :any_skip_relocation, sonoma:        "b352457814ae263acab63bf1f4f6dee167fa8d01bc818852ae87f309dfbb2fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c247b3d364bd7ecfec6ba97c6d597c8b0d521a614e1df31e57fb5fb108ad889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0244fdadef2fdfd56a57c54e976ff2bcbc852af9f62b216c9fc032350e2edff8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    PTY.spawn(bin/"kibi", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0013" # Ctrl + S
      sleep 1
      w.write "\u0011" # Ctrl + Q
      sleep 1
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    sleep 1
    assert_match "test data", (testpath/"test.txt").read
  end
end