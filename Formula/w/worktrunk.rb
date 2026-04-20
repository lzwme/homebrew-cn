class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "97ccd6aa9fdd040e6b562f5a0e59340c256e95290df23e4dce212b464b979660"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67969965a02aa349db14dac7fa852ae5cba8a79e9840519d59c3db8ea49d06cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5119c0a33b925fc1affaee81cab663ec8c32822e4abd2f4977f65002af6e88ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a51c594c95fcd92e21062ca00d329b746317021116d48595f1b8871808074d"
    sha256 cellar: :any_skip_relocation, sonoma:        "854a24200be11c2763874b04291c171c90de90c10bf028a30dd68593a6340961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07a46e1adcf7e7caa530ba307b5017aaed2764fda0b40356b0da5479bb794a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00aa071a091abbb044b5081f11565cd8ba19c6fce54b7bd986c9c91dc974dcdd"
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