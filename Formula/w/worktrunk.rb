class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "4e2040aac8c8c0323e7ccb45535c969052f50998f05dbda5c0ace7edb133bac3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1273946e8b90d514ebfe055fe5e7d64a583c4c09bbeae9830cecda7050474041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b42873aaf675cd732f6953403710ffa1a43eed35ba076dc63a6ed40c39c8759b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2f51e9f4d30a6bd7d0ae91930e4cfa0a500c615bf531c6a0faaf9d1b0d9baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b85cbd0ca5399f4cf5d70da33ddfaddaecfc1b35e2462bc2a38c205d0aa14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af60be3886c09208ce1888539300442f96b03d83fb52c9de5092323ce146c5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f670e87670d7aaa17fed4a407d23969ceaa7e5167d3b41fe92f6928f8eca27ae"
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