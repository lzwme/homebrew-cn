class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "f72d0b7305ae8a5b764c3bfcc3f2fb981e413da4a2011191ee9a58438c48f4de"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bbbd97c8b1977ed63ef2313ea383b6d09dc4bf32860efd06f54535c70251dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb692a42f3124f6621fbc216d73ff842519e0f7ddfd5412de10ee85466347d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b275871c6819ec80608e0399407166c0957fbdfebe4403a951ad0aff4824f27f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60c2f51b752ef6089388dae8f1f7adfa3254159e910bdad28ae1db7c4055c4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1455752cd8cba3173c1029ba8f8692278add505eea7968b57d1ff8623aab99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4722cbe5f011b8943c7d8c09eaca647f358d1c47b4cb43c930658bb853725aa0"
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