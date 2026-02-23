class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "2a06a64c8884c2f22b100df674115027f22f4ca4b1ba6d0ccf2f16900925037d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd7ab91fe9b2f7d6be7c796050788ced344895ac6c8c5cbbaa37a20d8679a521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd3ecc12f229f473b79acfa5f7942c4bbbf5039e12ea7e859f65d0003925d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11acc98ba75b065c7d75ad53450cd54bc1b745f9d2b6fab6b7d89a1a91bbd87c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a054f7fa7cf4bd0b7803be6aa9506520558653ac9bc8bd6e0b408957efa8ff68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66771637a11fea9ef0c08dc6cf40541a82021c0587eefde5dcddda11c8a4acaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040ba7ffb675c24f25e9a5b9ccc57a97e3282b41c09953e4cb9982e20189661f"
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