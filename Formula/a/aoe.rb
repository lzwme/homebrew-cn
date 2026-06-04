class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "358f1a989ba60d5004160afb82e80954f6af3e39e8eef7b2f6836142d0854745"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c5c1cca38582f5ab70833af531eee976c57f755635b5ab4b10fd00be94ce4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd253e0d784b0fd692f568bc0516709547216c205ed3d4cc61ac6dcc192d155c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a58fad9ebbdcc15632c1ff0efaa64456ae6d030104401f01ba41c5ce1260d030"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f3c0c50538c1ade7176d5d3d704043791b82be4fb31b38dcc9e2ba25d7355a"
    sha256 cellar: :any,                 arm64_linux:   "f778424a9dd9a347e9696b9beb88dcb268d3a4ebd777ff975d1778319a9e2245"
    sha256 cellar: :any,                 x86_64_linux:  "424a91402baea7779a1bc470a3f8a112c0446c73985bb7f1c80de6919dd1012f"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end