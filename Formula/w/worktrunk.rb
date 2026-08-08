class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "b25ba3c23f8bf46704a58bf46c2f7a21f836d3cc54f0db7595ea8354f2d03610"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ba9205e42c4d53575976ac47bd8a5eeda6c30c743413909dea977807fa5db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1bac467eff06a0113391ac06c6ce99ebf594759c4bf18ef940dd86fdebd0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17966f83fa629d3c9fc3227345c98a83c3f82af1421ba19d1ea9f0325aa8c0ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc54b3a75fd6ab7e6f689d704caec9d3d9b3ac8c821a0b372c486f54da060c9a"
    sha256 cellar: :any,                 arm64_linux:   "19235609155211428b08ba6e74ef67be7c400ba8697808998c1666330cce9645"
    sha256 cellar: :any,                 x86_64_linux:  "9289462d7c33c8b5803006f2418b416c457f7394aab5815ad7cbaef8281884fd"
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