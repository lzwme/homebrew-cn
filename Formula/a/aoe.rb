class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://ghfast.top/https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "4a255c3c43adb942f1e1e883b0120cdf4826643a4bf854bd7a171f730d73cb7c"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c65fbe85cb52a685abb2b203629f45cd729bb951e0c5520c46b51e18b2e9193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d688956e9ee1e5e1e76ae6a5c75ffb4d17a446f18af8586ec12411f9f6ee691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7a58dd5c501d790ba1ab6be136b44d0f4274b8c0ab4afa1a0a80665948814e"
    sha256 cellar: :any,                 arm64_linux:   "8c1c0fb32516532c8bdbc030f70b315558f86c277d87e2223bb131344fcef334"
    sha256 cellar: :any,                 x86_64_linux:  "d31448f9ae10d943a18c9428a3696232b8a824907ac9de86ed6e8ce1feaad319"
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