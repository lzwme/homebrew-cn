class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "9f8ddeb88cdbc50f0e96f9f366e4978004c5b894191a685d0b55315720a2801d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8266e7aad881858b104529f62a3d299a74328336cb581dfb7e13984358c70882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2260a69a212f918ddfe034d315e59aea4b8a446d6d87dae836f80bdf8210e6f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc94b19db3f894848c7a150f360879d8a0765771b8a27cdabb957006638af134"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a54f595bc5af2a7fafd86a7d53b970e4bc6198f6a653c95e743ceed86dcb08c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9111c0634d025d45de0c49f7d66bbe0a1496858613d7c784b0e05652421d9cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a545094ad1872b0d07ad7fbfaf2310c3dc9b3aaa57f947add6142e090855c70"
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