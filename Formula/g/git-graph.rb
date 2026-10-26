class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/git-bahn/git-graph"
  url "https://ghfast.top/https://github.com/git-bahn/git-graph/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "0694bcf963c7a0ba865303fa03f1b7382031271e651625ac55a97aeb340f36b4"
  license "MIT"
  head "https://github.com/git-bahn/git-graph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91e9379cb3b24b9862e559323c8779590262e957677e330c8719413326d03742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f91298b2e466ef7d4b2d598601af50af6bcedf28199b50d70719fc0d38885c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1597801d6cdb58b045a36c6e66c312b4cfeb582154d75106f49ff7da30df51e6"
    sha256 cellar: :any,                 arm64_linux:       "94ed3ae7076f88cf05f539b476eecf32890d885c582f68c78043c700f690a8c3"
    sha256 cellar: :any,                 x86_64_linux:      "ca6e92429a03ca35e0b8b885f4a1fa2664f10bdb4a36ec419d7a677d59a6ea50"
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