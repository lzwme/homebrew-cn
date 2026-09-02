class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "b8c2d4cb76bd7c2f266e3aa71d74f7a2a019b517ceddbed25fe500f6813b9390"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7103ad59602a68cc9c62f52f7549be22bf9173fc52d98de427b5a1749052a36b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca2f56077a68ecb5cb5011cf6d715e60a18c0127a6fbf0dbaf5f640e8ad8325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220743be2ddaf4dfa9089c531a2285a89d5837b6a0b4d70b37dad62742bb74cd"
    sha256 cellar: :any,                 arm64_linux:   "cfc0bb2210743b2fce4c9c6162bce819104adf6c7e2ca3e8ef0bdb70c8615cc2"
    sha256 cellar: :any,                 x86_64_linux:  "54f9e9617a51f9ed3317805a4611114b68bce2378fc2ad9cd8f9cb54dbb4edac"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end