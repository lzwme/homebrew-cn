class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://ghfast.top/https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fd78b4763ed3bd690c5d5edf98f284c91b8c0ee8c12a3724f46668288729e471"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad36282c8ffc44c60b905b4a1247c968c5f08659e7b4b8e98a46f3c8079329ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad36282c8ffc44c60b905b4a1247c968c5f08659e7b4b8e98a46f3c8079329ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad36282c8ffc44c60b905b4a1247c968c5f08659e7b4b8e98a46f3c8079329ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "80fe087b56137a280d78d3114748f9c41616582e8d56a659835f37b3557746fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf82e787122c4dfb651616012b1f038e8fe341571400767649e87569bb446eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aa1f89a2a377a5a3fdfd47de6dd9fb805885576665227913fedd8a5556b9378"
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