class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "4678545536dc44a417935f9ed2938030143c14dbbc3f3ffe5dcbddf1aff3798f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dfde4b0da17bbd9b00f13b7bc798bdd600a1f17ca10d4723b9651de76409a27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c6fbdcd78a4ca7e6f7e7a0381938a093f493579b5d8256c42f7977f6e84039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bba499d6c62365687174b5c7c3f700ae4da1df589c11b657194eb453e2746f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c983ffb3f6feac248a6bc2f87d81531f362839935c3c7cf4560a4c46510a6412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573a2e26862ab6a2c5654313dfd62450bc3173763239ad28bb84fcdddbdb9db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436f62fc1219dcb3336270733d6e11421e301ada25a4f3edbca32122d00682d7"
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