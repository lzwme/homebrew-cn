class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "701e96cc88e943aca0c2635fffb8ed5438bac23ec0b56888249e068d9e104190"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db94e2720bf7b8294028e63e810585e3f136f8f8ff73524e8e45737afd9067f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bbce7b41680ec86b934a9cea24c39716ce752a2070442386043d0785b1f9dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce72412296531fe3f56599daafa606af1aed2d7648fd5f9d22922d3a94e53e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5ebdaeb7f7711da713f70ae5dd82fdd3b3282fe429ba83c1e7ab71f2b6b219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8879f302d464202bb8a1f7783ed1ed35a4d952034a9d28dc2e359744c977ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f055e9abba8e12f8bdd1e66f0da9fc745439bb5de75f9b02d87a4c4672809e"
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