class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://ghfast.top/https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "7be891225955112195fb58e06c4d75abfe9ab388121a81eb02af93a27e820796"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bdb3044d2924ec3b698025443c213a31daff58f8cfaa268e648fc861baa7d14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bdb3044d2924ec3b698025443c213a31daff58f8cfaa268e648fc861baa7d14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bdb3044d2924ec3b698025443c213a31daff58f8cfaa268e648fc861baa7d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6cde75310075878615041b83b115a4b2def7119f41bfd8fd48dc0971aac804d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beb8a9f6cc9e5a876712d20fe8bb1058c50f1bce0d5716ab9fd499c9cd70822c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2856daa5a9eb7d194b6d2150120efe3c1362dd639b4b5791daf2a31af3e57e15"
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