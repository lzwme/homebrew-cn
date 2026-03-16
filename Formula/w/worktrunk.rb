class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "644c79850324d699fdc9c2a2b65a08cfe303f7ec18ac1429d40177a50786e0d1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f075802ca092e473ac996c17ec6eb6ace70ae825a14cb74ca86882be894cec88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2b68d0f7e0dbc1e971dace76b851b17ab15d5cbcc6e79eb2f147e3aeea4318b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8210073c583f6801bae0c2a1ffe8fe7bed0e4df367dece90c14f98c2f1811017"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cff04ec62c4fbedc4f5e046e66569d160db62d888163186b38bc7dec9e99938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3f57b0928ef2249b8b96b1a0b6abdb01db4ec8906a7bf2b1bcb7ec98b31e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e97bc2bc630d2e19c8a78868bfecb4121d8f43c33a7965705aa8ebe8b837ac"
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