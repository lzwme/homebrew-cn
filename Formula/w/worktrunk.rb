class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "8160f0afe8287f3aad52e6ea1de7b0cfed01ad6d3d60ecdb952db6836775eda2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156ef0549072a9bbb0a9da0d2788131f0d64658e4c8b627097e3d6704a0861dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fbf2a6604ce91643c5a25855f9801de22da940c4af399ce864d1462837a20bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99054cc0b41d56098bf87a89e3e819498cc5f657e9435a9f46d881cc04d0b97d"
    sha256 cellar: :any,                 arm64_linux:   "b25791b94e6a6d066ee8304b38dc441ebc829cbe75b5cb61729420f1dabc89a0"
    sha256 cellar: :any,                 x86_64_linux:  "8683b469f520dbb0f1b22e68677ec1fe0a459e3aff448d8b609899cb7a3d93ff"
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