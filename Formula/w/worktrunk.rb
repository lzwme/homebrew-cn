class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "0a7a3854968a75736198d90cf756111ee2e54c9635f5d01d81657782a336db63"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa20174c3cf13352458d58be751e650f718c1a15e1a52b201889e2c1bd33375c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79e5d9e19b8402e0cb16cd8581e89a415881cb611f86a3aa07e604eb693dc57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48220658b0128cca7fbd01097efd8263fd20a0ea1747f7613aa9b275958a99e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4bec0167c607fb2929c51e5e68732f56ccc949e5641b262819f0a86f9d459e2"
    sha256 cellar: :any,                 arm64_linux:   "7b00e30180bdfd37a9650e3aa93864ae011f8a5405731f2a27e1fbdc8fae0e39"
    sha256 cellar: :any,                 x86_64_linux:  "62fa6de6a00c79648fce84aa4af6cdea940bf24d72592b465765ed3257a07885"
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