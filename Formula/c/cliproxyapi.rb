class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.57.tar.gz"
  sha256 "83b5ddb7097b30924a5620a5f242a15fc8f3097d6bf0c7235ec50872efca780a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fb822d38319b0e69c2f2273b330b1d24a4d3b9d94ce5974dde60e22000c3788f"
    sha256                               arm64_sequoia: "fb822d38319b0e69c2f2273b330b1d24a4d3b9d94ce5974dde60e22000c3788f"
    sha256                               arm64_sonoma:  "fb822d38319b0e69c2f2273b330b1d24a4d3b9d94ce5974dde60e22000c3788f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dfed59558a59607e50c895c2e997e868d0f0d013411acd2ef89ee229dff9d80"
    sha256                               arm64_linux:   "bb5c696d3b5d6e8984bcdae233a515c8f06f8b9b386aa2707b7b180b0066db8e"
    sha256                               x86_64_linux:  "1d5c1ac5dd7dc5da9cfb53340c92dce1368a86f429e63516331f42797a2e23c8"
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