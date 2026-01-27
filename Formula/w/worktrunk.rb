class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "cb16b7f7f4eca9757738b1b30186a6236f4b842ead9f7146298972a8f1c6ee5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ea389d653f60563f932b38e9e8faeb41f9aa4419c299fba96178f32360ed7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada09898c413fdb60a8c998b616322012823398c5a8ea1f0fc72b92a764563b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca37e99e5f6ab3accb33a00b9541040598e02bc0fcdec351b150050f30a20880"
    sha256 cellar: :any_skip_relocation, sonoma:        "496355ade423bbcfb08460a7b367c31eb986cdf565e5e19e9e56f989b7327e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9ff31ce2ccaff9fa9c194bf092fde5cad834d564ac143237ede9665ce4cf426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606e21466ee8d2c74cfe3408a13248fab804a32135ee100c88cae672c9a334ba"
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