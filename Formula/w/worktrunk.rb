class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "de90ebee9ef1673af5c8680e19dbfe3d992736efc47d0688a322985dd7d776a7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c856ea2cf0722f3a348dab0055d17d389642eee79b1950cd5169a1720204acd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f952bc5e17d223c6022e35591d88754af75c49535e1d422b7c1718414f79ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc71c15b0d5bcfd28570479f4de0494d6943310ae3daa406bcd672db95052173"
    sha256 cellar: :any_skip_relocation, sonoma:        "f93fa5f27cd5a712fa718a35a437def8b61669d5bacff8969c54f56f5e6eb074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d049cf44f7e8abaaa11e570a5a48925b695ca2e9c2a8f4f64b5bf58010f73017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78e3ffa5f58d2c7eaff388f1da95f86d8601f9688668d1f44e677037904b179"
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