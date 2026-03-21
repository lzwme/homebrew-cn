class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "1c38b9272906d9093309cee02e97c5bdf0c9424eb21e2137f4e7c2af3a9fb980"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19cc1a03996f381f9e5aa5e6938dcf7e8204812ba3c4aef50370264617bb148c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43100dea40b34a4e9e6096751071c9f37d7bae07ea3fdae580f3884c93c1d45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f4d090b44f6dcd696270ea9542f62bf3a5554da470ad82225cabd915ab21ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a43c9c09ef38e312bc422be3bf1e56941c67a5aa2b853baa137ad769c7d0ff9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e58ef54febbdab7ed6ce704f6a6aeacf50eb23f0f18766fb70d972e035d5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2d9ed70931a6569a7868e3ba6f83f011e60f81b3ac40b3887047fe850748d7"
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