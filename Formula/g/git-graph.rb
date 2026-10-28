class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/git-bahn/git-graph"
  url "https://ghfast.top/https://github.com/git-bahn/git-graph/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "b2f9184af26e200e952cde24904bae8a57abcfeb5ccd38c55ae8f3f693c41569"
  license "MIT"
  head "https://github.com/git-bahn/git-graph.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59a32f7666dfe4d56cb4584eb8f6cb3ebe5ced1a990d2712b242c12f8a490526"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef93eb2d8ba2da7378ed0cf0dfd6405ce6de4e8d1e5a2dcf0380f276753b7899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "497c5b47bda7bd9a6d42cc18d842bd1989d6be6a1be53fc6a7c8af71ac53b22f"
    sha256 cellar: :any,                 arm64_linux:       "75fed9f1b4a1ade419c7475b46def26957e08cf861023de22dd964eb3c255194"
    sha256 cellar: :any,                 x86_64_linux:      "d2656923d0df679f2718609aa65fa6b7a5008e289f976517050f265ed461aaac"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-graph --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"git-graph", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end