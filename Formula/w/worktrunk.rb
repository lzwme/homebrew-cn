class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "5572465e8b8978a8fb91bf1d988d796e30a0ccf89962a35cd544b61b0e951590"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e604e815d1587e03ad7e04151dd0314958e2a9fb14af645011b35f17dbde46a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d1e0eea316993092354484be575f52a995cd5cd5836ff0c098cae5ac463338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3f0a224cf0ae89f24a1e749c3b76a7282515931bc0bc5d6a5f3bd8ec22ae39"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a2e4aab2dfbe2a04ae9c750cb4d878afaa0116152a82854cbdc0fd2ef71dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a775c71e91eb494b447828f6aba7a20c51c3c605e1250b4754ecb05a08a6bf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486f4110d11d1b7ea913ae9704c083b9db82eeab766015e0d219aada3f822ab7"
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