class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "b91b5c3958f4d1b778dcb21203bbfaa5af0c654a6d29db64ad456ad30517ecd8"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8dfad661dbab244042a45c0882eb4be21499a94274bd65690e8a1e5332eb0f5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "febba661d950607ed5d0318a00c4996904b99460780a597d883a6b94be1f7526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fa4fe647395af28fa2e8213feede6e31055259fec47339b99c10a44664a4afd"
    sha256 cellar: :any,                 arm64_linux:       "aff153e45f46cc62f632b1ffecfe04d31f308573ace31832f19fe278c3ecf4e2"
    sha256 cellar: :any,                 x86_64_linux:      "8a5c603d62933397f0e4515a41306f5250655688015b8faf0ac302a0962851f3"
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