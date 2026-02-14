class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "0db270d45b6f7deeb08c72a661df3b23149125cfe046b322c77df49148da6d39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30d7dde1c1bce64b6e552a708ee694d3de437dc5555e46872a0e78cb6f9eba34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0718b12130d8b011e52128a3340ae6fd6d697968359bed77b17f3dd16d4b9a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f266411503215256a914e03fa7dd709c956b85f2006302d0884a0a855f141e26"
    sha256 cellar: :any_skip_relocation, sonoma:        "04c1be6529ba3fe1d98b3b6ed43cbf8227e623c97361f153062b4c2891696700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46c8a390cd4a191c2991c56a67a09f52ab87917bcd852dbd351b57c64a929d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47103ed3e87244834fc779cc11b213b8e13997583b8a084c261537dbf470e94c"
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