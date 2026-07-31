class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "bae28c3728a2537810147c456becc416efc590f55d8d14ea905219d417dc7f82"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c903b0ec75144d4959553e425f3a30e5d7765f3b2c22e5871a5da529c83f1cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0bf5aba71b5f00030ebff8be285540c06b302be1c6428eac88d2b786f0f40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff569b49bc9b0f4c36dcd8af2f2cec7136aa7582e1c5f039ff3d283357b679df"
    sha256 cellar: :any_skip_relocation, sonoma:        "a54d6d90f4c16f5e871450114919dd0f608749b648b1a2d3f9bd8b4ee4d75a76"
    sha256 cellar: :any,                 arm64_linux:   "de52cc753acecb4a53ea496dc014e84a006752775c330ae8803d3497c0cfae79"
    sha256 cellar: :any,                 x86_64_linux:  "b0ac261de55808ca463363ca1ca7bf15dfa51fcf3dc1beee68d58831bd1e9d7c"
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