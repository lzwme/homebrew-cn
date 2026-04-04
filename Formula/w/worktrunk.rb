class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "148c88d5e6eee37220584645a907755dda232025f35c605be91a35cd8d568ec4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "030809cba84227f492736831b6c7e2f62e3e8bec8d5b760a9f65dd592eccd090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0484969a9db40dbc5cfc70d8c6f2ae81a05561fb19ff93a625eea772c18c84df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64696843a26331d0d3ac8b8aa3bcc46f4536a4bdbc45bf5df72b97dfb6ff3cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "593556a411e7d2e63298ce9707987d20bf4b3d1ead2441653df70c2797f0dc30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03c900b86b55d170cd6dd744c4a0fa2901db376cf1982d7942ccaad2153bcc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763acb07cd0a17a5cbf67e02628e290b210f9dbf1e30b721ada579ae37a1e0a2"
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