class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://ghfast.top/https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "3866b98df7c2b5a55c9598e493ddaf7c9b6187dfa570656259221e1a14a6b59b"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f867756de3169c361546a9012a92142bd2e81ea9e087692d20dfba836f1f59ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f867756de3169c361546a9012a92142bd2e81ea9e087692d20dfba836f1f59ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f867756de3169c361546a9012a92142bd2e81ea9e087692d20dfba836f1f59ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4aaaf5b0b069f4f6a72c374784d34f5a132c0a863980fabe3a81de60330144c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc0f7b3b098dd80a299c437e201ba4ee24914411b04f2654fa2fa648eeb17ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a72668b0c4bddbcd00c1071ff02dfee7b366f4895fa73ed618c11def360135f"
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

    r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
    sleep 1
    w.write "q"
    assert_match "test.txt", r.read
  rescue Errno::EIO
    # GNU/Linux raises EIO when read is done on closed pty
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end