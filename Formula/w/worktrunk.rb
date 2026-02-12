class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "8336ca849b8ca0099ac2537307bad8f7849390839203f4d35982ad269f69d9bc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a33e495112f8a18d8bb6f36ac371ca5f8b260df0ee2bfa71888154c6736513c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1d1e6fc6ec314ac22c5a4dc5bc13bc1968a369f03ab969f6317de5087434e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa604881cae8b34a6b004a30a3c8cab48223eb2ec2896de4610d7f8feba662c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f4dc14bce908c528ba8a0fe48acf613eb96739144a2614cd38182b6d7845da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59eb75ed47c85048ba283d60d6b02c0eb99229f0e8a62d2e2d9b42a2b3483d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a946c9661af0b00b1728455ec5275acab1c7c58d909b6ac558d04c65748b642c"
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