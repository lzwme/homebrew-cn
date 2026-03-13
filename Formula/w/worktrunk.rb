class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "69cc0ec15ea6c421b2a1d339ed4ebc0c88d74960a262a334523efb6635286cbf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc101eaffc9f6d01c2c1cca94c45ce187a7ed01882b1359b6567ab264b0c83d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc66d867019d95d5611809311d16c65c6cc8d887097b574ca354f4421740a29c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829694040e5846596c88087e99b2230c312017ee10b7717d2b7ff0959e1d126f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2acf60d6bd06388dc8816e44bff48e66e205ec6453154108bde20fb380730146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1646d2e37c454e20103b032485fb9832d04d949ffd07d96968dc308ef3236a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcd308738f68c6f6f47a844832e18ad2fdd82a0690c1c8e61c120b43f9f8cca"
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