class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "5402198d389e49e6faef3980e310fdddfe190ecb385a0621e87aa61697e8b4a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87c9099b0176fb9bdd427b5528d0b6fed0c33e33cf1abc2943b2f9a2415cff2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509207bf3df19bcba9d6d3671bd1bb6bc7a9515b0785736f60f1097b412c6aa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f270d939bb52c8baf29fbadf07d7f21cdc9f76747ea89847a3bc9ce7d07089"
    sha256 cellar: :any_skip_relocation, sonoma:        "921bbdb273f4a947c39c080a2d173e0134c25a96b1dce17c8179560be730ce75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91e48ce1b6eb5c49e22157ae6bdc2bcf7708bde7014f7d52665ee991f994977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5d790c8827fd36842a3adf65cb934d75b8e639784a1da81fd05508dfa8b80a8"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end