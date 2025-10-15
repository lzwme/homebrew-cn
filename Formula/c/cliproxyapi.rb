class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.8.tar.gz"
  sha256 "0eb90b4e456f37e89f85b5a1015a410ac7af70ce14ae14063289f6a40b9e939f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "27421642f933e1e4ee76675679015c687c2a819829a886eb7c1f5657ddc18133"
    sha256                               arm64_sequoia: "27421642f933e1e4ee76675679015c687c2a819829a886eb7c1f5657ddc18133"
    sha256                               arm64_sonoma:  "27421642f933e1e4ee76675679015c687c2a819829a886eb7c1f5657ddc18133"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a39b4831c18be7f5f9272c0cdb4471c2c4b46deda4796631be58bb9fe107b38"
    sha256                               arm64_linux:   "cc949b99cc17f6f1673e91d081479c1e27080588fe19224827866fd6b9e820df"
    sha256                               x86_64_linux:  "24e76d27c45bb4946193977156629d8000e2a4c25d50a11662686ec222edf449"
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