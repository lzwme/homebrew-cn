class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "54d285ebcea8428e349aae6d16578c3b6b50d07d6967f645d476f8b92f1211f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04fb7144a01d26973052bc4c01a4fbc9a97a38c86ae9e324f56d720517361351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbf1237d18e7feefbe7d215a5e32936eded657495799cb1ffa35f00ef386e315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f843f4053557b100417370c4b5f54702fdf1e9360494a6eaafced670507bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e9b858696a743d441477b5709d90638b604ef88eb2b918370baa6c0825691c"
    sha256 cellar: :any,                 arm64_linux:   "d2a120363a2fd758a2e5cf243cdbf8edbc32f02140eca0e97a660e1e680e5e5c"
    sha256 cellar: :any,                 x86_64_linux:  "fcb5d248d7a1cb98f28c549e40b18e809ab9220d3af460fd44fe7c78d0f44b36"
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