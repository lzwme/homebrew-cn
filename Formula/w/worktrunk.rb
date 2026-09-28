class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "c533319363f874423b2075226cc4a89e1a383ac7dca39b11ccc132371a48d1ac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "490e2c26200f861018071cae07a6acb97a3034794b3b3f3ff5ed6cef0d1bc1cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a81fdf5cd9b897c4f32880f3ee92bdf409c041e52a9b03b6af31483c675d9b44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4313a9c917d84628e3d2aca2a814ef5cfe8e1aeed464848932cf26bf74b54cc"
    sha256 cellar: :any,                 arm64_linux:       "b0625506e77a937ecccce7f6501a3d4d79fa252232515ef4eb4c6f3711d61c2e"
    sha256 cellar: :any,                 x86_64_linux:      "741277594113458d88f389f402162ad5440779d6ef9a9ba7ab92535d01b20ed8"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["VERGEN_GIT_DESCRIBE"] = "v#{version}"

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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end