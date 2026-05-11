class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "e774213a95422d0f48629fdb231d4591b6bcf5c2844418bc68e8ac978dd83292"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0232726e3eb1b02eb3200c6572f67ff642bb9e17c5d7d90e31d4568863345032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27aa20b21c271de00de6fa5acb125cab4c4d577f6d2d0309773fb62fe9a98a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b31bd8087c886b9198040e8bd56d46b7e3451af73708bdd3ad4169903335f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eabc4f8967cd4a3f10922fa2fd4ff845c7a09e366e0241ed22e4ce963f405909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8814715e5bc03ba2b8c5dc731189d2e1c76bf449476949d2485ba8e4549a2a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2a130584c360042532573529b69c835a2e49e35d2d3a21f05fe02239f83c03"
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