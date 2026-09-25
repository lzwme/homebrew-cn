class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "cae6d4888f7111d7173f4ecd85da330d85134beb9c9b763e2aa494b994c761a2"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9f91380f53953d79d796694d5072d92d38e1139b06bc12b87c80343d50a0c47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f7bb3dd67b191076e2e4f0d87b877cfae57e013d8e9d381ea800f6d89190295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c5124b7dd1680f7d77d2b17fdd63e07a268cbc16bb8e39e2b1e264b58acb342"
    sha256 cellar: :any,                 arm64_linux:       "aefbce990629a96491e0dd4326653eb368caffb20269b7c7365f2024526ad16f"
    sha256 cellar: :any,                 x86_64_linux:      "3c3c1fd926424e0f9478444629f5937cbc68ab85655031a8c3f52564d46ed795"
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