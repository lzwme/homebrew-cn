class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "71d403533eeda37264ae2584f62e6227645fb491598afc3b093c06c4364f02ac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72d8a658d6a01250642bd554abd9b5a0fd333f758566927e905bfd157bb3902f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf48a8069ff95e78747f8a275a6e8dd931cc5e2dc2c22673f6b3404263f8516c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "474ebc7a0308c8bb0686e9a1c60b74af86f7176e8b0e6f1bebbabf4ad194b6d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "579b47b566441a2654e874652ad5c2a2dfc304de463da73749bb4f75b7d3f323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9718917e12dc97a92f5f1ec634248fab94ff60616f1613d1bbdcf946ebaab0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3ee189d64fb76059d324e0d4dd245cf51bf67d15d00117345e790583a4c3e8"
  end

  depends_on "rust" => :build

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