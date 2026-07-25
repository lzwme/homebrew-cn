class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "51f095a2f492b7334ddcaa7c17630b6a04be29fa6186f5a6182088d98060f3c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83b402894292f9e4e198e097746ce77249fe1ebbc90f83644f9127ea7a45204a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8412e81a8b3de6e3a25383bfa22424868d750437eff2ae3b072cc422abe79d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d47ac0670a4c64b690d227179d5c9295127ef0d5fa7b750a80d32fbf9bf2f02f"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f4e7440f7f06617574ca054e274e09472d2f9825164bc99aaeee57d056f4cc"
    sha256 cellar: :any,                 arm64_linux:   "856ab41e0b2957b71fdbb75eec3730cd02504fbd51ba245c7fc70aa7132cf6d2"
    sha256 cellar: :any,                 x86_64_linux:  "431b57e7698eae20d56ae3d1d3dbc31c0b8f32ae85ee13f7c9c90067ccfae293"
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