class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.5.tar.gz"
  sha256 "b967917b528c50ea780af632a6e2e4547bc9c5bd49425b948a62eae54c090382"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "514c5d6396c14d74ed35253bde21066ebce6d86eff466ad5ce4f6710d91823a0"
    sha256 arm64_tahoe:       "f1476551b06df3165f267d0adacfc55990bed7827bc2295971d2c7c5cc82654a"
    sha256 arm64_sequoia:     "58490947b921069e5df10469a5e38d4c24539e20a1f2fc1761b33478a0403e03"
    sha256 arm64_linux:       "367194c6747b831695283524d13cc7f92796cd558d3f5c3f3eaee836460a7eae"
    sha256 x86_64_linux:      "0a928d75969923b83ae1cdba6676ec3a9c6c3bddcacf2dfb6f6e2a8d23841eec"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end