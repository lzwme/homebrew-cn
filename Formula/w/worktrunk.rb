class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "da5c0f8bd9d595ab3bc4a45cfe7dde15035660e590ff7d318ac3ebe49663fc25"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923ff2e354d19611db60329846a447cac19e0a0531ccd77f38224e15ab265ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822b0a85aa7be3a1d1c60a830cd40d2c71084f525e44cf45715ab697937e5e2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed742a2d3bbc072765ddebf8f99c6bed27fc141f55a8fa8392b13deeead0ac4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f43724c45f410218b45a6fba0eb0f30a9392aacb85a95305662e8be1c2be6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0420022bfe8c2fd284288899714b10e49dee52a9257456fdd23f0f0eba6fd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f0972568c0d7b1642b1bfd8808ce895ac0a2366c803b54b9b9c6c2e3b92ece"
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