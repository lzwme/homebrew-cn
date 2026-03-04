class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "40aae3e7578044e6adaa18db0de3b600952474f6deb82981620d2693cf4e8c06"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09754f73cb50b53677670fadc082d3a53596357507888550a271940620eddae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a94c57c5da108ad2161269e64c712c23c5518e513a3f23af317b0382005c3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf893df9a85eff79d3a5b9bb2cbfd2add8686c896823cd51b2cee6d7765f6bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "58678c465b6df296f14d60106eb442dd644bbf7124ffa2c9899d193d8fbbe797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2f988398de2849cb6a4ade99b67c24868c2692bdf81ba1966e9cbd1db6f5bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e65cd756037cd1324aee40e85ee3b06e4a2f22661b05cfae2b8f08bd4894f26"
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