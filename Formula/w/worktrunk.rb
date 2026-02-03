class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "935a04e72df06f1d739c81e962edb205ce0b4f7352479cc3b027ae68332fa422"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf25422080fe5b9b2ea0ce4600fd97e34fcd1a9e7fffe109a0dd657c54f4e881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469553503100b134859ce67a9674c75bc2db6f2243950e9e6c93f6d1cd183f2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d708680b6722e0fe30412362b96a0ac9ba0ab56272f47c73f7eb8cd73ab3312"
    sha256 cellar: :any_skip_relocation, sonoma:        "6165dbf582a11b1939cdcc93f34e8f2c2fa984afc6e19c3fe12c474634e0f291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7dbd599ebd8d9a4c2ae6f541fdf1a7391ef5aebaded31ca41c84832bc16bd39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1627b41dbc0768874e0bd87fadb206aa9b5fe8eef4bf001cb0da509a67e6caa"
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