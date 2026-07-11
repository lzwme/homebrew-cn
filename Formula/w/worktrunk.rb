class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "2fc0890c78aec812ef07b247dbb67cc2d30571868e45c302e0df12cd98456467"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df298942bc1f12366b8b1924c0523c666369bb499b36222bff87dffde8d476f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7cee30742523bdd43820b06a2e85e9c7b668440df9ebddac9683ac26695d8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f265d0dda3d3e3ada5b8da2c09fee02e2424fc14b798151b79b6e007643fe248"
    sha256 cellar: :any_skip_relocation, sonoma:        "80bae56a239262e476b476c23c0cb2d46e3b57317cd9614bb642392573347b7f"
    sha256 cellar: :any,                 arm64_linux:   "099d29938502496a2c87461a5218d930b2fe9efc55ac999bd65885002544eb34"
    sha256 cellar: :any,                 x86_64_linux:  "14b35efa20a6544bd6256b1d494c9a2d30f662e2b57848f96c26f6745fbe20fe"
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
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end