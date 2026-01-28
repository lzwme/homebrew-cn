class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "6b94a4c1f035941aca2868ef3ee6492a1e4c6caf36631dc82a154be70896a9f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75004dcb2fbba12d745f9707c6fb3d122bc75d91008ca0ba77da998088707e2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "376a296e9f5dc2d115d29efdf71625598c12173a744e46286e4b71cc82bb97cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63fac4c2f183b2d7ccc8d5ad37bcfb1c4805325c42b7194514bbf0cc2372bd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf056caadde94f83afc8c93941be5a2fbac62d288f26a4fb5e02a2211797373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c02774b1f88bcd98a32f7b6f320fc88dd1fccea5313c973d9bb0a3e43a9314d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436d59ed2e05011669d0488813bfa2f6817c0a5b53f46dec25a61f127a0b5e8b"
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