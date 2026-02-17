class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "77e6a0636b65653331b6d4b1f8a7d95b466be5a7b17cef7bfb7c06175cdbfc9d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3082c389fe94ea2beafee8f298a6e1d44cf684b8760ddb50626bb4a3f416902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db23bab421ed866cc5c3471978f0c3ca1f8cc89b6dfce1e0656d867605f3a590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e38420fe1646d254b0df27a3b279a518a157719948d18a4a564b433647c6e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "28991907391acaadb5536b0b6fd997582edc672b83825e6bdad2feab8cef4e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc51830461ecc42349e11d629cfab3991f3b24094cc4be8b0afe762459a7b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f6927091ed186dc7e2a258aa3ea7e5b20a3f0d075e41ca74383c9ac8490ae6"
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