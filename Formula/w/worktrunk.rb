class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ac6f7d83830e021c611d3b7680726825905189cf41caabf169c40c6dd71fc8f0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "771c06a25ded408acdcdd12aac7235eb7250097d2799d6cd447d8205b28792db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948cf28794df17f661ccfb911f4b698435ad0fba4770acf72c53d61ca41bcbaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb4518cb7196781c515094fc336f183523e2edbcfaa2721078b1076ceaae4510"
    sha256 cellar: :any_skip_relocation, sonoma:        "9964418aace5c02bf5ef59f4c78f3bfce6c52987365c72d2fefb88cd2a580e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e471e1dc07630993c2e6f6c9f47c10670968c8bc31bb51087a42dff3244f8d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31e7e08d6f3258b487da6d8fcd2f82d6b7e794e116cb04d05a1c62e2a0a3a67"
  end

  depends_on "rust" => :build

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