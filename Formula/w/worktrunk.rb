class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "03b2f156a27a3c4310d49a484e2c606578e395ce1134466dfaa26a0ea0602887"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c3bc772ec2ef5318c12b16c8d6b8eb81f26cd61914023d1234b1cf8b8f0415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca92be6b43f5872c09dd8c1cbf1f4e1be7b8ce4da42684eff03e06b44e1bf36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7766ff9fcac8d351827679aa32a4d544cfe2a8dab3f5cd9cf79a2ae603c00aec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b696123aa51c867934b17963261547d0332b8f4b4bd1b48c8990b9d59187d76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8e2d61dc0ec599429f59c248a0e3bb4bcf3802fbaa2629698972601a55f646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37341d26919faad1feb52d41276843c3cb2331b12d7baedcbbc29730dd90fd66"
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