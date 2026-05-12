class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "09398b0340031e9ac5e6ccd09cadd5e4c3e4f04e5b66cc30d50bb54a03409bf4"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afadb910d1acda1142018197e41f4cace5c145326495e32b30887353ffcc667f"
    sha256 cellar: :any,                 arm64_sequoia: "a9a36e182da7dcad4d76050fad7a61dfd95b2020e30ed3d55deed60abafd01c8"
    sha256 cellar: :any,                 arm64_sonoma:  "e38cc37cdebd461a92e540ae3472a509c67adef149a61aa5744c7593d05ee8da"
    sha256 cellar: :any,                 sonoma:        "df7df9dd873064da4aef067ea9e698f189e0df0da890e43841c4c75e970c29ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98bfe8000b4d17e6a5bcc8a73d344c7414a3f7f8a7ec40782eb2218e2929b4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233200b931a5ca6bcddfdad36043eccf0d357b57ae967144210fccba688ddae7"
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