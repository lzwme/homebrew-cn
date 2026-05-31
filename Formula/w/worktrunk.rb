class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "1ab263a09ebe903162bc5f808a8754d98fc03cda50444b701c3ab162170704c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f2d5fea34590a8a2fd1a603aa6fbc23c1a90804e6c47e27240d2745591619b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2712e3cd9fd55becb39fe04507583adfaf8d1b91c3fe7e89b082d9df594a2646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65251b6b9a7c24a7351d5c329c5a9319295b74987d23b91ba498e63d0de4676"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cfeab1be5fea8e911f4c06d445652bd6130dca3504b480b7b283a3e841a835"
    sha256 cellar: :any,                 arm64_linux:   "ad9c884a1c35782a7848701d86fc8d4154812af43a6da88a89eac9b8d12c11b4"
    sha256 cellar: :any,                 x86_64_linux:  "3b9584760f0b55243bd8e0e8fba6fd66df4b3abf34f54f06c443e95e6e79d49b"
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