class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "abc7a8ab25b9b089848cf503a846a1d87d38dad293dd4b139515b9a7c07260db"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66124d90e6c91cdf53699060a38acf4754f0eb80508c6e5ded6f8390813c2e01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c490e3dfce0b65d3ad1770f2929421aba3477c5fa1cbc99cbcb5c2ac07057659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9902ee6bc2a511c906d75ac4cc1506f712c9c571acd97399900995a939f46aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e137f253e0e2be14b0e767f90f0135b74086a1d1e5d842ab40e54af2b09ead"
    sha256 cellar: :any,                 arm64_linux:   "d0dfb04ead8a9fca305bab7401c87ac0c6452ffb9d8ca9b1e126f7a35130a6a1"
    sha256 cellar: :any,                 x86_64_linux:  "75f6c516d09a7fd30a84eacbf84d37a75674f676a28addcb93b34a59cf7e5e37"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  def install
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config

    port = free_port
    pid = spawn bin/"pitchfork", "supervisor", "run", "--web-port", port.to_s
    sleep 1
    assert_match "<title>Pitchfork</title>", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
  end
end