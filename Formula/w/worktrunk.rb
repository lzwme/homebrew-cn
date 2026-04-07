class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "9d467648fb574d8315970de7b9c703929a56363710eacb5291533a3d1e3646ce"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f27530435da861b903d5643cfa3a1ae43cadd85e42d1d6e11fd1f55095baae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127c1ae4c9451fcac465491f9603de194da92ba2500d5c514847fc9c7eab59e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe9850674c243155195e6c66e014ebd9979f7a6bedf5d3123a10cd183952309"
    sha256 cellar: :any_skip_relocation, sonoma:        "e90dec49ad04acba89f10bf5bc2fbb0169e0bb81b85878f0c95c4e47fa06d6ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f77cd6f79fd22b7e154e9085cfa79796084430f019931a465719cc187a9b821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce0bdcf04ab860f7fdb82aa10723fd11f3e50dfbad77e7444694032bc76dd0f"
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