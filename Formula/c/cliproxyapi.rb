class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.10.tar.gz"
  sha256 "ae55e00cd50b8dbb9a56a97a45effa8847f8173e596f1251d4166b4bcf87251b"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "5f56bf5d9547b29dffc576a4333ad21d28277beb306fa8d061583e2e72383725"
    sha256 arm64_sequoia: "5f56bf5d9547b29dffc576a4333ad21d28277beb306fa8d061583e2e72383725"
    sha256 arm64_sonoma:  "5f56bf5d9547b29dffc576a4333ad21d28277beb306fa8d061583e2e72383725"
    sha256 sonoma:        "58ef6045024becefd24d87f7b226e3a346b797b1f3b67b1dac010b72296cd1fe"
    sha256 arm64_linux:   "c6361d9d53080aed5a12e5fd55c08606a582b177c616e8cf17dec923c9da82cc"
    sha256 x86_64_linux:  "2d3cc77fd4c82b6fbe0699fed1d36f77314b69cbd19c21c3b8654bcd557f2e6e"
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