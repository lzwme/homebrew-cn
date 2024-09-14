class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https:amp.rs"
  license "GPL-3.0-or-later"
  head "https:github.comjmacdonaldamp.git", branch: "main"

  stable do
    url "https:github.comjmacdonaldamparchiverefstags0.7.0.tar.gz"
    sha256 "d77946c042df6c27941f6994877e0e62c71807f245b16b41cf00dbf8b3553731"

    patch do
      url "https:github.comjmacdonaldampcommit4ce866de7a2e1613951002ff61563a80e19a5c0c.patch?full_index=1"
      sha256 "0837555e28ca95b366932af02cdbad41a26d1c7f57545f04616258fadc6e96ec"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9c3984d37e228dc23f0b719b3d34a297359fbc30831ab3b98cd0316031aedc80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7740df6c776c2e0520337ca8e5683f63315cbf18ad976c2ef859971ea43e4489"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aef57b839b6f12acb5fab08b71b9d3956585b4f019663230a0fc1ec867e9db51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db8538414b3471e899497ab7462383c4ec27b23f8c648fe41458da13218bc331"
    sha256 cellar: :any_skip_relocation, sonoma:         "754cc6905c2716c06f975fd4b151f9944d94885252510844ecb74e3bf35fc7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "e3965b38fb5a5313e282da4ad32cf5e710f4636b9c6d62fce6b7f41ac63a5c70"
    sha256 cellar: :any_skip_relocation, monterey:       "12505051e9e0c7d5dfdf69c369d993c3e5d9bb8e07bee318e7f91293edbd170f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a257eddaacb831226f45e836759ef90dbf3d2a94e302e71f2659490fcc3ed1ff"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "ioconsole"

    PTY.spawn(bin"amp", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # switch to insert mode and add data
      w.write "i"
      sleep 1
      w.write "test data"
      sleep 1
      # escape to normal mode, save the file, and quit
      w.write "\e"
      sleep 1
      w.write "s"
      sleep 1
      w.write "Q"
      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match "test data\n", (testpath"test.txt").read
  end
end