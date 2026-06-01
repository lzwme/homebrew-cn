class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "315159b86a2033f89363674fd194cb4fa89b13862f4773e295de075f308ef980"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869116e41b4963e0ed240bca8dd6b545138c57d5ada2e7cbe972e69a46824938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b8cd729e9fcb0c840c3cccf8b2cfba2db14e1bc9be2e323451517fe5c571378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b244e32c17bb0cd1dfe057369c54569212e7884995061afcccc324cfff6227fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e66992c6bf279b9e42e5fede70b1510876cb78b7908fb0adc82ed6a4d300951d"
    sha256 cellar: :any,                 arm64_linux:   "e9166c6807c6434b07861d6f8528065235416a69b7677dc15c000b581cc02e0b"
    sha256 cellar: :any,                 x86_64_linux:  "6fdaa6256688f652f599c82bd5e1f4213fe20d199b15572c1b5b108f410ac775"
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