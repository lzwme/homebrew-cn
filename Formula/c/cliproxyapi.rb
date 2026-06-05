class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.45.tar.gz"
  sha256 "7ad93fc88653c2081f17c9ddf1b1c982527e9cf4c1e3e284c1e0c1613bbf742d"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "086b96ce01af25e863ccad5ad147d5cb09e36f931360ae03caec6b4d1ff6d0c7"
    sha256 arm64_sequoia: "086b96ce01af25e863ccad5ad147d5cb09e36f931360ae03caec6b4d1ff6d0c7"
    sha256 arm64_sonoma:  "086b96ce01af25e863ccad5ad147d5cb09e36f931360ae03caec6b4d1ff6d0c7"
    sha256 sonoma:        "1579b1505c70fbe6cfdcf8df5a31e7b874a972735efc2c53fa3bcc5cb92689c5"
    sha256 arm64_linux:   "e6ee567837423d481eda2b45ce15c0772148904166eed08838ca30f28447a4ec"
    sha256 x86_64_linux:  "fac2900616cdc014a4e8b3515af880d24f73e712845d8e8fd770dba59fe67832"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end