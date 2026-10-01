class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://ghfast.top/https://github.com/raine/workmux/archive/refs/tags/v0.1.269.tar.gz"
  sha256 "4b1a061a12967905a09288fcfa5882680f17fa6ebcbb2194017791a51631797b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ebfd256bec70d5ed27abdcd33602bb72cee4894b414e418311e9eba02e8bccb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de3bc4b5c05c81387ffad303f5f95a1e2f8a5e8c415b11c576fe63f66bd48dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84d61056036755abdfeb812a2aeabd214a56a7379c29dace2d7d65882b6b6a1a"
    sha256 cellar: :any,                 arm64_linux:       "63c29c4b63b2b2146317442bda56ae00fb4df69d379b4fd83772dc1b036975ad"
    sha256 cellar: :any,                 x86_64_linux:      "758731e85c74d8e8a34ffefd94d1b05b2b923ad838eb17dd0fab7bbc0d1964b7"
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