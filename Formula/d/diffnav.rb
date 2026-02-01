class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://ghfast.top/https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e2304e5cb87c47ff3927f401a97bd24fbbd86ff6e939ad21c51d7e03082821c9"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cae61f63495e7c88fc5c9f36f4130b3a135f874f8c836c9a78e3838136f4656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cae61f63495e7c88fc5c9f36f4130b3a135f874f8c836c9a78e3838136f4656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cae61f63495e7c88fc5c9f36f4130b3a135f874f8c836c9a78e3838136f4656"
    sha256 cellar: :any_skip_relocation, sonoma:        "09cd99e951af25edd20c8e983a421fd080ee94ead8d8ec8465375d68d89bd189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e9a86f4176f066162d578b715a0382e3064634be204a1d0106f53a93cda46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81faca9d51751125de89e2f8a91a5e8eb97bd8ee502bec30b4157fb894e0b69"
  end

  depends_on "go" => :build
  depends_on "git-delta"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/No (diff|input provided), exiting/, shell_output("#{bin}/diffnav 2>&1"))

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test.txt").append_lines("Hello, diffnav!")

    require "pty"
    begin
      r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "test.txt", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid) unless pid.nil?
    end
  end
end