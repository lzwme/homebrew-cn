class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "904311d08c49f6eedefde3e56f4370a8fee3c3c7aacd367010ea5cff6087892c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fa9cd5f61e250a09965a24fc9bc98e4ec8437d5ad1eb6abc5aa6e2fa4cdbda7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41833110ef8971c844030a99d89ba44bfaf9c68b9e170f4bcebeffee7da65d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca74eee8111e5d9fea12cc27e8bb52eecab23215a2ce8a8492dde4e99fd3d67a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d416c332dfa27d0edbc4d2c2422fc1de134fccf9d37a44124fdd6c963cf1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "460e97969c96edd5f50e216c5980199679931c7e0bc9096e159d841dd3afe08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c17417809bc56a899cf47f95653874e3e1827a2353dcac660e45e3b60857e5"
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