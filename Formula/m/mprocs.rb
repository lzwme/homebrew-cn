class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "34a56708b4c562ca64d9dc1bf21f138bf15fd6494c1d0b3c1c8da9e42d27b5b0"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4660b579c769ff9d92f58c492c1a3c71f21ead5e46a7efeafdea2e4a6b5d69c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e77a1ce871e0020c8ca6e8dfc250c569ae841c7d1ea41253b5bc51381ac87f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08fd9548d080c92ddbe70ceb910b144916711c5bbaefaeaf33dae8cf20bb9712"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a8c256082269703ac31842e10c0c32f6652f860ffadf80e0e406d52c9a5bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1e70f7e572b0693229a5feb3101936905491bcb6b11bfb27d8719f2f9662dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "326387f1683ae8859ec0a6676fee7ed6d0350532525b8672549e16380a249953"
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