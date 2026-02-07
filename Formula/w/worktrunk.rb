class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "8a68033e7fbe6d166ca99aa088b90513c2ba40cf874aad0911586c1dcd3e5dd3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d073c7402a12618e95d685581cc301ab0986f12d6af15e93e29af8bfc11ef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6df03bd977c30bb2f48f47c876c77435eabfaa3a92e63fd1d8831a3b4cc944e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5909bde987a67246d026abd20fdc48d425901a6eee5550fa498ec986d0c861"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ab4887e327df0357e83ad92223d2e45365974c0a2e723df6c32b2736bd35ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fa1644c96448358dd614156110bdece2cc64a44defe55c3c064a2050a90ff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9552959c683b3babbad7cbd69de089f49b47ad2b0859fe0ec9f6ab08a2e08b8"
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