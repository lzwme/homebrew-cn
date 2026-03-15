class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "3584ec00a1a75030badb9343157c8f895695a5279f75c16550eb6f2cefae52ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb2eaaa349e729d1b7378938a780dd9a0597d5275aeedc0d7bb85b619cf7421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c56b3cc6c4cd4c6602d8158e70ed4c711fda399575161a8ae4a33c4eca9faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c91ae3b8a1041d061c3c5783df6134b26c1957d04abf66d3e42166b23271c7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7d71c3cda9c767c4fccdec529ba5b0c943c722f18ac723f918708134c9a8745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73a5a2b1a7e069308804c7e111391ef96c50c6eb9b87a28f96cca38f40abb61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7e559e1413d6b5472468c10fd5cbca8e63573be40ae58bf32d3715e570cbbe"
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