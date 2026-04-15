class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "60164123f67f975d522161831a3dc76d438c510ce75120f1fa7ef8a4dea4ee40"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cc0d8fd41de065d46f833fdf6da574d628b35f62aadcdbca5b7687121efbb54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7688f329803aaee063e2d09f6dc30bebdd4f334ffbfc477d4f6ae7a8414b7323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccb96719a74647fff24ae2eb10d0a09d4c060c3151f852560e6e389299dab82"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cc323711984670d518568c5e4899797a6f03b7a39b581e88957208d6c59edb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6e6016167e7aa372624423c2e576fdae294c66ed2854889b6823fe2d20001c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307d2fbd872e9483d149e33dfd029fa4ec454ad95997af5da2594dbdaddd69f9"
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