class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "fde29b291e6e298d397903fa92c26424ac07ab0a90d1d31d3bec784a88970207"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d964d4ee9964009b72f1ba35863965340f6d9f081047e2cd2e261ea44d4ab80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9849525c27f859bacb444ba2d7830bfb1a81613018eba93c6e89f082c51e9f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab86d75aea43560a5053d235faa544ad640f69f759d91614ceedbf307dc4058"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4123cb952b82bba591a2e6f07b27d6ca785b689aab804960697c2fdd824561e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e21019acb8104ee183c57a98c320737045a89c16b234fa7610dc7ea601c90bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe9b96d4d8c3591502e6755b25fdd33813c97ee3d470b9c7d6f1c206e1c08b1"
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