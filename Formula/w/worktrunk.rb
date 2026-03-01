class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "50e2ef9db8ee31d4f95d728abe1400c47e6c2fb8ab5e1cf8ccd6113936af8dd4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2062f0238441fd12a13934577661edf11360b0d395c5eb5eb1a3c85597a0724e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5eb9ec45f6f77d7fad14ba8d1b7960966a4450239d493e09eec4d92a5b15aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98247a2010a044809ea85be8e8017fabaaaeab20a49db5e0bd7074d40be3acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5815cd6b8186eb41cb8af685222f6e1389b0f7e9a165bb25a1cad98734554f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f4fae9b001681d8defbf24652c483c0bfa3b806b6dd85e7175403556b0e8ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f3c27008c18b91b6c2f00573e11e569ab364fd25c7f3dda5354f4db1dd8b72"
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