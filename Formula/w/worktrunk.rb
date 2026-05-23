class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "5889fa8711d1033d962d2ca6d4f09dc9ab425bbfea2ae3ce1e9d5fec7da080f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9ccde3a0e93b52340530ff4256c0f08b7e8a2d7871b2669c35c070140cc152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd31bc4dc36aad2458985bc48075c63a401e5792313967cb0a8f92e4bc9e62d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53968c1ab9089e98d842de3c8f0521187d7c1c2143a7a9c8394c7aa65adfe34"
    sha256 cellar: :any_skip_relocation, sonoma:        "a90894b0fe20443a3f78909d4733d6b826e79d20e8a459fbcca3e772890aaf84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b663f145eed521ae99f000ce5a693a8291f28cb8f409bd9f40e28637e0fbc9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b781506734dffcfb8cf32595b3d6cf13f3a88da4a5e3031405eb98543594b11"
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