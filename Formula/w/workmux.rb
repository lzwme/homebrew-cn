class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.266.tar.gz"
  sha256 "edeb0ccf05fa2ddf23dd84eed3caa8ca57e264c6b53f4ded06618bacdc324e4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "089cc1303fd7fa01c3f6329e855f3e2dfaaa61a5938dc08db1f656e2ad74e759"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d990be07c720422d887c19c20094daf79dbd176ef77ff3fdf87fdf877c5199cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b8e3af0f831f46aa9d63b7a646aee0b9b20d3ff0a9777cef3b645d6ba411e6a"
    sha256 cellar: :any,                 arm64_linux:       "7b26238c877fc9e28c2f6876009f2341c11c3314be5b732aac5a729471852c53"
    sha256 cellar: :any,                 x86_64_linux:      "2d431ec2f3401de4dedae8e7e9e4d887fd32e7a1423e7a505cb535cb93a05789"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"workmux", "completions")
  end

  test do
    socket = testpath/"tmux.sock"
    mkdir testpath/"repo" do
      system "git", "init"
      system "git", "-c", "user.name=brew", "-c", "user.email=brew@test", "commit", "--allow-empty", "-m", "init"
      system "tmux", "-S", socket, "new-session", "-d"
      ENV["TMUX"] = "#{socket},#{shell_output("tmux -S #{socket} display -p '\#{pid}'").chomp},0"

      assert_match "Successfully created worktree and tmux window", shell_output("#{bin}/workmux add brew-test")
      assert_equal (testpath/"repo__worktrees/brew-test").to_s, shell_output("#{bin}/workmux path brew-test").chomp
    ensure
      system "tmux", "-S", socket, "kill-server"
    end
  end
end