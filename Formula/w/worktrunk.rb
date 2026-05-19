class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "cf7caff2ab4fd460d80b6bd8610e85c46f9feb29dcdf9e4321c2180a2ca6b99e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31e130bfcf2984d23a1cb13fa101802dd7776b55d927ea62587f42e18abeff1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1232b2b73e0171a9f2e041be1deb2fc97610384868bd0b6e389af7a62b5c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71654e9a14af7773b7ac2a001b07ae22d808afd22d239e1d01d0ba8c666fab8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0bba590faa244c111bb273d1e1994ea91d661a72d5d1b4302c253a6dafe63d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7254f0eb6afd7dbe06282ac0d2f885b5ec4b2f0392e3cd085393dff4a609808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1175ea5b64768e3bbb8b225e4051a37c00d038b9fef956378da0bb325bff3ae6"
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