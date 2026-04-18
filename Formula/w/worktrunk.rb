class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "809c36fa52d9f1cbced1d2d37cef2cd7dc3f5311d29c5e6745cf7d2ba5d49bda"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eac50623763c7461eabb267cf981e3841538b0216b1a4268bd3af0c115b3bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80652539eb2c72c0a2de76acd19281f3033eedf3087dd2aeb988970e5a85727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81f5ff3c9123cb05ffbcad568b809448105430b38981e19ed987aba66288b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3e235e3f9746dea997c67302bbd232bda30e8ac0a4e26d628bf2f1b515ae52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adbfbe2c2fc8036e3429c1425ea300a422a94cdbacdf571985e22065fbc1a37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b15bfa74e7ab0e216c1a10203290d1b4e5e2d0f1fb0885ea167c00d9e6d203"
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