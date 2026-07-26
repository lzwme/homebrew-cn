class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.69.2.tar.gz"
  sha256 "984936d68f7a47afabc8670c2f7433da2f41b4815032ab472d6ced67993c35d4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7f6ae90930d08e463ab7cafc81a3cb81d5d403331fb533dae6855994ccc30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2339377976f5d6fc6d30287cf9e6eedacd5002edb11ea7f5270d803d5efb5d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43f86c790e8196c7950eaeaaf43afacc20fc2a02ed41858a8ae99a88b5a6e82"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07acdc841d4667fdc34a9d6dddb5909b6c1bb0de15a2b39e7387016c7e75bfc"
    sha256 cellar: :any,                 arm64_linux:   "0f208450b4b59a9d30d45d1142ddbda659290811a67fa6dfccec5d68ed4e4d1f"
    sha256 cellar: :any,                 x86_64_linux:  "2485f9fbf47fadeaa1ea297808ce481aa9f29534cbcad9aed1ac0168b081dd05"
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