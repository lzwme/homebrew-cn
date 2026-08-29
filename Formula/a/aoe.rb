class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "47e3253590092544d162db6fdc8eb52f4b0af2fadc6bdb512553331fabba7d3b"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b0eb9f1aac9b2a171b2b5a4bc2db2f3b92b2cb3717a3b10dfd7f595ea73c6ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4d38fa7cd4120e8d9e01683cdba1d363fa1697d06a5cf7fa3936facdcab30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72116ec1a6ab06242af6ce4d9e4453cf8466e3ef57c66cb5ab6e856814595670"
    sha256 cellar: :any,                 arm64_linux:   "7244c62fdb4cf4c1a54201507924d1b855d87d4fb4f599d25a8d30876301ba5c"
    sha256 cellar: :any,                 x86_64_linux:  "07c1b29cf2c228ec6c0db7d4bd0a72f0f42a14e03168465fdbd2a4e39d6e9f06"
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