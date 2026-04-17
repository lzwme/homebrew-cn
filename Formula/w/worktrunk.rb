class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "5ff6808b5d7f2e81421074ce25b76bdda2e64749d87b237922fea2d589ce6839"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bd0032abec684841219c25ec7f0d9a9d52d14e30d24f15a5fe95b37a49ab61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc5480747c5db08e1ca9631b057907e0b04a518cabaed3fa8552959a74cc3afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "991929ea432086bbbd9eae0b9a058d2ae8b85d76e1eb81104ffa0b04bd2a6b95"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d6f7a785314e06bedb628ead5dec1f11997a22701e020c0924cf3f1499399c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6dea9565e225db7a84dba9ff7c04ea5a0ae5240e3112c30f376003efb08356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef8d551737ab8d9e909cd9edcb1602824bee2d35b7ae42db39b70fb1d24405cd"
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