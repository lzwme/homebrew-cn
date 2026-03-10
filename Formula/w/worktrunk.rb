class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "2d20c9d6c17d7038f4b9f3d899900350797d2a677f5543dd35dbd5d967f0d06c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcfcfb20db58c257cf2553d606e3ce84e1e1b15e4d0dbbe4bb6246743f946679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfeea43f6259885f84a9f58659e1c6179aa65b0f6c5c19aa4e72fbcdeb56cdef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad2177ec09bfbe00afe9a779c957b389b664cb062f36859bcc43203b43cb6de"
    sha256 cellar: :any_skip_relocation, sonoma:        "594e5024b3a09be222a16ceff059a9064c595d8d9f1e75c424f4e9bd1aa101a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f559ee55df2f5978ee1972b55d40a0da51c59955a8814113128064a506b5ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ea6392fcfef6873e246a9cf308e4f6a2a161578fe104b827cb658b43037821"
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