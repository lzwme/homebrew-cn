class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "cf9d38b74ef354eaefa39c3516e6ac303c0133ae952b0a573265ea3400cbb3fc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7702bb28770662c968d8f26f943a0ea15bd1a3d2c7b0dbe10671a74789bd83c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a428280e46162bd55b0cc04d705a6afc934e1883366b47f567b1475bf0646378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ec250f0f3ad09fbd3685cac262a1f7313ff0d1aa8a6d538336a0efc0435580"
    sha256 cellar: :any_skip_relocation, sonoma:        "46489e2dc25dca210743523dd3baf163a8adef6f2041ff34645b978e108dfde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9479e6674fb366279d4d5606403455094a20c858464401261ecc547bdd30e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c35c9fdbbdf52621407e515829a97fb4e7509ce91ea3d2d878f4dcbb26e6b6c"
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