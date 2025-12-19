class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "813045cba9104663ab9b48e157aaea453f019d20f47f90b5d4419111f96ca4bb"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc0af6cb49947217dec8c025966f80e987a12a186ab8aead2097ad5a528a0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886f38bc3ee5843fefa787cc4327b81361358a00b59ff0bc1b396b452322b9f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cff9d58150c2dfd4270c3a0c3ce5614ddc3fb38d4d672c58003672da0bff4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce875188b391dbfc4f4fe4b8f60e86243d442c1b2a44dddff99effe1687637c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2104c8da2ba882839bceb5e7ba15ca63b2f0cfeebd5925d6132cc81176bf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2191e0c791dee2d8793bf6245362f85e86ee55c80683eb79db780e8f0e1da5d9"
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