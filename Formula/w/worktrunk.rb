class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "ac729d37c2ad195cef3aee056bc38d9f8250eb3ec953e2493cb6b091d41a793d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29316c00c16ce3d6392a724f121f22ca07aaf31e3b45a4e32d4981036421b832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24097e2a2d1cd26718ce7cff5fd853b77d48ea72f2018c423e6b206fb1978451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7268d28703172f7839c7164cb620d9fb8a5eca90eb3180cf6c00baf6ddc8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2bf3e911a527b24cf29d81b160640b075cbceeda06c3107393af5b09d5484e5"
    sha256 cellar: :any,                 arm64_linux:   "a6e934d58aade4db06aba4bf7ec7e80d08788bb795258e802b72585fc96b566f"
    sha256 cellar: :any,                 x86_64_linux:  "959692649e65b5ddeb0bec45cfb30618d99f63cf397832232cb7c96af98ff4a5"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

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
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end