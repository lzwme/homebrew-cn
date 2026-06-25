class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "47eb2c75543678279d81dc96d3a216fcc8a5f5193f8a9416426f199ab3ddfc3b"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2181d8f9fe28963eede387b41a1ec1b2425e34c3669b042a543823f28a5b3e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf26266935bd736273b3e8c4b51d44fb422d14b9b1e1cba630479b5c5022e7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25da5e81a8effdc61f776863e3b38ec38793e988b09975825606c1a1a138a7e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d3862e9ea2c079d51f0cb0b74bdfe27fd6d7639777dbcce55688eb86b9ec0c1"
    sha256 cellar: :any,                 arm64_linux:   "0482a33ca2d236515983817ae2187e26ea7c44098f557e7cce80f42ba580f722"
    sha256 cellar: :any,                 x86_64_linux:  "670296880ed600a9f4a615159fdd553d7338485da558a6cffe739b11b5daeda9"
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