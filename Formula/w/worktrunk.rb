class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "617ddafa8c3695ad0a82b7b8becf3a1817aa9b9b01b211adc5c67d5bd9031644"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c711c86bd97ab8f0fd095a57a2f00d7644319fc1ddf2707dc80ed6797b128d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a961bda7d5b87adb219b23b7c1dfbc55214c5aa927c2072e2820104fde97c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "473d21199eb75332c7d49eb5b4012f6fb6a4f067b8ff0cf204a4be6e1faea74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7e6e30e8f67198b5a30c5050ad6c6f3315a0c74b2c3e66601a3c8565ebe12a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730d3dce873fc44412c654ed9ff2b82c8eedd79009094174dd77eb21b2388026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119d90d8e87621c45a0fa82321b831bc1876eb883c858e96446375883cd7b85a"
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