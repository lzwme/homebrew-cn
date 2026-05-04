class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "70eb0209bd8d740ec01a63eea3110c56f91d23ea863cf75fd513cbedd43b3f5f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "459d362cefd207d7133a1a4276dfd0bca05d6b0b5cf3b8a29d9434f29a898562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6180cedeefae3465d3b9995b030a61e7e1b5e36a09192a9b68b062838ba643a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ca57cc955dc986324b9ff244be294343e4f11ec73abd5c8a17d26b2240f28c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dba0a5e8f01866f285dd019f5e9678a0fb1a52208dd3359d7cc70dfe8d4f16f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87aec949afa28d4d9e8b346175853892e6b90d3778add0ad909a25136fdffa7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2ed502736a10ab4585bb60382b72c07a958670f24cd9924c0bf62ddd0558df"
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