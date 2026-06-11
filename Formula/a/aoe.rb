class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "141b327b03c328458a1a93760315236c315629aa125b18a477c7cc344c19d329"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7bce8b59c4a4b4e16a0b0e3f2485c111d770251bd8b67a8a86a805a35082a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b117fbad020e4593a768692f43703f9c55adf91aa21c39522625f55550d37d66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36dabb7de012fef5e3974da722124f9922bde573d9b519cdb8ee32f13233bddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae02e6e7271a9fe7c7b44a44b7fa6981f7cbd6b10593a8b2fa4a0f0251d82863"
    sha256 cellar: :any,                 arm64_linux:   "d570f142bd5732cf59e07d4f9e4bc66f616f2a6a0cec9ce6671fbea62f20ba9c"
    sha256 cellar: :any,                 x86_64_linux:  "6faf8c2b8f6e8c12208cffd1c7791b551d005d21ac163972feb443bd4eacf4fe"
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