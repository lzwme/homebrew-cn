class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "a7561c988ce358f7c878e7c457ebe3b41f40e617acfe23396ad53cdee20f26cb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9bca3f8391cda4417f75186a4c70795a4761f713c6beadff4ea3891f92490f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b37e4c71c838dd6dca251ff065b937b748ac57c7deac3fe8932a5758c3017d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7cfe2313308011d5e82613ba6d5b63855b5b16b8f25af8721550f3070e2138"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1340298d0574f1755ef34c78ce46451496ed6104197f85c24f21c99ecc5e443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cef1f7acb3e024fbbc4c072f9191ad75158785d3d2abd8b208545122b474ad6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a1fea0cfdd3bcd182248182dfd1b84c99fd82b21fb981ddfb8f3edeeb533d1"
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