class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "cddc11fd1ec36847d91c026e7e298300cb6e9fe78116df6b78696923384ea336"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fa4f56d3dd4ccead5c61d13147a718e19067dd37189af494e16d51b041f42a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f145d7bd19ed386c33f980d10fed9eac9dd07b9c8f64034a1aceea8e09b045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcba21743d8d62cbc195b043540117bec529158f85df97b5e1e8240191202c34"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de9fdab8e2d05e4c4044ab75ceb88b37febda6f6868d0d55a7b897501f47e2b"
    sha256 cellar: :any,                 arm64_linux:   "a471797adfe52b7edfa0643d4447bd81b3076263a042933bca6128d33ebe5321"
    sha256 cellar: :any,                 x86_64_linux:  "36b1c72240bf0d6e3933d557501c60f6e1f30bf1c4400138f74e707b94f279ce"
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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end