class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "367c5f97cfbdfc39abfa9bf2484c160abbfc779429ded0fd02976baeb10297c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249fbfa4fcca1cd02bb904d3dc23a938e975e84f85d0fd55de606ecb6571f9d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6aaa84e49fad6f911a2340e64a699fa000f3696af309677a8cbdb1fdece26a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "937861d4bd26a2e2fb6f128e031e1fb553b3d552457008b761cbde3f9e9a903a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17b7b25a3125a3b9ae6c54b1407e3e95c9324746c56559836e57f0ac0ad901d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f15ec9af3cf368448eaeb2333a5e7af5ca22fe12f18b1e0e86644a111e5cb3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8709ebfdc1621bb9534a5ef43060c5b56b2af0235bf90f15c6965bf97d1dfc67"
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