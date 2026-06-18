class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://ghfast.top/https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "38fb3321111fb67dcf7a4218c4aeede795bee8168f3f4e8f59a5234629e896da"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b0328f924b72643d481d81cd8eee269c46bb525a0f6335d3f73306181acead1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a873cf12fa7d64216dbd8eed6bed6686f2f2bbb136a3e3f382603d414f08ce7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b76fcad02792266e333263b1cec3ae0949d9d473176007818cb829df757d4e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "d221143c9d8daea53b4dbdb056ab5e80755b7e70759c853dca5e53baa6def700"
    sha256 cellar: :any,                 arm64_linux:   "555b23cf7cc4388bab345b4651e1b5bdd4bb07598db1ae59c775baad1fd113d3"
    sha256 cellar: :any,                 x86_64_linux:  "03d6a46519cceb91f62dc73f8b8da94aa90616007e7c47a97c185bc12bf74cfa"
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