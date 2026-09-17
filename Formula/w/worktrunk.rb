class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "75d71da3f5d1a47a4118217f5b2afbdb5eeeeb0d7fa32b86cd5112feeb7da80f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd95c30746d531952864f13054e301f530e2bda378de0a6518e2b573424c99ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1259d19b2b7093d65df2fc49f68b31e86471ccd7f0e44d6665586d78867d2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d891bc3fc32e1dca2cc373d31f28ef5fa61190254d5fcaffd2d9726bed45ded5"
    sha256 cellar: :any,                 arm64_linux:       "1a8a63ebb9bdc2b40a79e9a5c302e1d72f93c7e3a752d07ded956c55c573c839"
    sha256 cellar: :any,                 x86_64_linux:      "9f37be8b01406986d73eed172eae311083fcddab02aa2979360364805743575d"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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