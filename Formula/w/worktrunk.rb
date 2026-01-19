class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "c1b3d029b6d6b852903d6ffb0c7aeb9d93450aaa4099ca2c285518475a211f8b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e912c8b15f884b13e5fc8e5c7c9c88ef802351ba4fea3b9c8c69a71b539379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845806c46f51bc87aaaed05c7f10648653fc4ca13917631f72fa4fefd0486694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b49d4ccd13f8c2b5c7bdb98de838818b1fc29b7d8af673662de7f7699a70b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fce8d0aa7631dd2462a79c4f915650217c26d215a536a3ec71f6b78f9134bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb1dd14b7dc9de1fd5ba3a1852f7fe128d9a8f84eb8bd35c3b8f6425e88dd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64f51ea3144036617aeb326a2993e1a5fe41466bd27e9ac8b94b4b58635060c0"
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