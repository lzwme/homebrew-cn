class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "c2709fb69afd2912e963aa655fa50572d3bf94f6aa77bf468e22648dae1018d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e6a771ceff2e40c59953bb049e865885d5094a9634becbed7a65717505d90e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106fda58132430b2e0591d8eca92582c4ea891b2177adc0c9ab9ed9fceb6c557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1aba0f0e74c6eae91f57e32a52d91f560ced56f222cf411bdb8fe2da943b4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "391953ef57f07e55eb012989b0a08ac0124ab110cd6c3b891e614dc8cb3cf702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02b2ba9e6712a24cf062be8bbb06f5aaf0d79ba0147c8929a4a80e51af4fe5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea3eb05cde28a47f65c08041f4c832ce007e905d6d569fa0fd0b3010c5979cf"
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