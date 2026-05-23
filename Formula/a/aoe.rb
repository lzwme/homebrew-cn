class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3d46800ef03afd1206c02b91cc544395061de3f17ace8b31ce4290514876f490"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e00b04845c31e661e0b96dba5ef28ca3125e3d784a21b11c33928e23935c2af7"
    sha256 cellar: :any,                 arm64_sequoia: "7481d84ff4185617923e8cda9f748e91ba82574f9775c05a5f1db379f9ecc1d0"
    sha256 cellar: :any,                 arm64_sonoma:  "bce1feffe73a60f4603710425d80791e80715d1ebeec1d35ce183c33cdad1986"
    sha256 cellar: :any,                 sonoma:        "0780930dba123707e261caec605f309f54dd3c43efb08265b4b38cf75d47d47e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be13363bb2dc289ee3b82acc803ebd59b399768baabacc6c6758e2c682115235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b43eb4355e8be7b1f4aecebba35c2a0740efa572ac1ba02f99830980cb283e"
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