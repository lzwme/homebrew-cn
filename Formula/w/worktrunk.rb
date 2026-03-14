class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "23a1e650c3a706ffebc99c20f64837da9bb0bc9a0b44acc8bf5fb39bf2311a3e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d335f30955e0633212a2306100549897410c320c9cec1b98b47b6c257f382a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5937bf8ef9608820ccabc5029aa9dbdcbf538d174ddaf0845c03932bc60f8072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c14421e138666c4b4b8f26e8e764f3d34b74df271f492ca792398069da20edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c7dd9ee6755bd573f7044384865c32de2fa9e49c0c171461882856ffde46f65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4654fcfecb3ca063319d82a2d61a5d83c647073b2b78346d4f611bbebb7fb2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "099b95c2864f113c817173376119c99aced5448856bc79b20037f3e846582e10"
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