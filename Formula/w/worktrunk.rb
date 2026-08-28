class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "e8507f20e0395035532184962c73c1e7e528a11150ba3a99f6d0725e9b066e90"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4949ce376e70bc59c133a92120193b512104c59ef4a4541f175d4ae059be79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfda53b6a0aa46d57882ae14f06d7b89f6fb3fd0c74c2605f49b02648bad7e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5248668238bd5c8a640498ead05a4a895ae8f6bddb3190c7c7e686bbc136e176"
    sha256 cellar: :any_skip_relocation, sonoma:        "725609d394af7314751a74030206e9b5e54ebfd48e3f5ac8aca7f6bd412ce26d"
    sha256 cellar: :any,                 arm64_linux:   "1c442d8bef02403c52570e7ee4f266574992d103d7be00adacd11df3a0a82b3d"
    sha256 cellar: :any,                 x86_64_linux:  "516fca3e9e40b6231e60ddbf2b6174c19009637452c6e2cb26c5e30f258649a3"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    ENV["VERGEN_GIT_DESCRIBE"] = "v#{version}"

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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end