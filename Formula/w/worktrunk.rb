class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "3e9b467ea6cb4fb180074d079e54dbce9b845baab9cafe0e50be22db55c7691b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adfcc0b2b790121927efba18f412aa971fbf03b88623423071d8ca29c60f6b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bcfcdc6ec7ca85325938933b010fd201b985fe02436fa0aa86aef6f46afe6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fdad75101672538e4847dbafbddbc647acac2cff5ede84bf17fc32209383843"
    sha256 cellar: :any_skip_relocation, sonoma:        "9868a6910b846ff1fc81850a633ff074d02dc84e5d44cd2b760185cc06ec9e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f52977051b862e930b1470e16914052e86b26d34c2f215ff49c90622bf3a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc4811f5be985e0f57d3336afd3d8a427253c1ad5e2a8676f3af70c703130ac"
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