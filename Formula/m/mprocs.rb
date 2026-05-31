class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "fb05b45a91aae5964cad47c919507e65bb2b026c1dac317761008ee59d53dd85"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a1b34d8108530bbc8690b936e18ef6ac83b8902600fb84dcb0099c047f3a3cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71f2ac7e2918c48b7f3121f1bae19f4da212c2c47b08736d799456228e4250e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600d97647ca701ac8c5924cc8ec183bffee737abd32c2343493b4ac8e2bdb704"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f88b92f7997afe6525555794ab268ed8b8c10f4af069d4233b68e8fa9ee190"
    sha256 cellar: :any,                 arm64_linux:   "3c3fe1aa518ab5b15d3cc5b6266ed1b76c41c4df9a5341c98cadf7c117f89e9d"
    sha256 cellar: :any,                 x86_64_linux:  "d692d8c62f21239e11345bf8ce77fde54ecfb1972eb3a4b381712d2d748dbe2e"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end