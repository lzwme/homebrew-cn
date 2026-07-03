class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "9fcdb9165d3eb4034eb1218d8532f693273bf85fae617b21eb1acefc58d9ad93"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "127ab6636fa3609814714c770781bc4aa0d89c53e491709005f6aeaeb14b0280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1369faf18ff99495ce4ec76397c3d4858a5510f5bc8525854e5ebaf7f747faab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7795989f4aa618d05edf99515f4f1ba28ba0758a8a7dbbaa6a43988e178b3f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb921559c1d3f83bdd8ab2f54a5df61c2d408d6cee69dcc0d7f8f0f14e06470"
    sha256 cellar: :any,                 arm64_linux:   "c007d64105cf69b3a78900b37cdf71a7a7bfb5afdb5989ba68a27df22913458a"
    sha256 cellar: :any,                 x86_64_linux:  "04848eca636d201f4e84b3f41b12862c6cbb314fcd3f15a144489cd2222c5fc5"
  end

  depends_on "rust" => :build

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
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end