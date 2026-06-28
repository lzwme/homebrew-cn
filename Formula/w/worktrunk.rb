class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "688c39314f6060137a66fb35033847e542e9029fda256ee968c9bfd4aa8d5303"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09ebe71678d2b21d9b3fff84ed2083cb1d4ddfc03da491c54119c35bde649fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00fc5ddeb70d7685d646b52405a8ff67de7d74a1cc2acf3a57ff0bc13690d90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b97e79feabffb3b2b986d3e6474b1474eae07f1c7b64e962ddf57976c484711"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c2429e214268663a19f4c514e9fe10acb3330573ac985fc25fc7584720a1415"
    sha256 cellar: :any,                 arm64_linux:   "8332805ab3c0aafa4dd830f8c653c221c45ac4983e463bde34ece732da62d9ec"
    sha256 cellar: :any,                 x86_64_linux:  "fa24e43f5a35e0bd65cc326f321c31ab8993652ec539a6504a2afca2433ea1eb"
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