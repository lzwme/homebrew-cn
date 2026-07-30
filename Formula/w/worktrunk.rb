class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "2ebff158d07f2a7abf5828c871a605a766c6deed7f4afa20f4014918505f0b22"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d1e6d8f085ed5beb0bbea15cba7cb96cf981c5e6b5878a0b702738e1358fa36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8446148105e8cd0fc971d73065ccbff09609d851585563edd961a9f14d0dcbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c41c39c3f4c7832acd53cf5f8cc087613d7ad3939cc50f8408e06a1f1afda37d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c759329141893b8a9d9fa73e31ddfd0734d86def23160d2ff16b33747278f85c"
    sha256 cellar: :any,                 arm64_linux:   "20d93b2baa88a9c2de89319207893c2d5cfc8411a6861180e3697c78227327fc"
    sha256 cellar: :any,                 x86_64_linux:  "15e29dee7cad22ddb50224301126562867ad6f6bd609491ecb3d29ef8b854f7a"
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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end