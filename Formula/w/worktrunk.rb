class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "d5de78a1ddfec99ec89173090b9aa76227da19c72a816eeda4d4b4386c2cd21f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ecec36d8dd010da05c732773fc4e379417b0a0a63311fb41372e66a105f486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b206aed8b1d31c9bb85e31e85052ccd9804521f6fad5d645102d3b7f0a00e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807e2ee4f840e643d0c34f30b2a0eec6b4e7b7e0907e5d6c89609589b2652e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c84bad505d8df1ccb3fddfece9d54173922e1c93cf0cc0580cf521e6104cc07"
    sha256 cellar: :any,                 arm64_linux:   "62cbe59d58ff529029a2d45dd6bd05488ad108a1e84bf20af122795ab078ff2b"
    sha256 cellar: :any,                 x86_64_linux:  "5f06ce49a4573335484826aa930402ef541e8346e76a6c97c7ead4eeb53959a3"
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