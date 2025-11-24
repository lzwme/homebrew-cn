class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.12.tar.gz"
  sha256 "053ef5022609ad13acb71121f10fe6a9b9f4c194cd2b1a6626d96439875f18e3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7845a93caf825702582a5ad4770c365b17cbeb593abf33d3db72314e9727cdbb"
    sha256                               arm64_sequoia: "7845a93caf825702582a5ad4770c365b17cbeb593abf33d3db72314e9727cdbb"
    sha256                               arm64_sonoma:  "7845a93caf825702582a5ad4770c365b17cbeb593abf33d3db72314e9727cdbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7074fc37753fa5c8deed270bb863188e0357d81b9a34e4309682f496755908ca"
    sha256                               arm64_linux:   "aa037ed3c2727f1d6922d2e1c386e06bc3067b1f5f09afe91986224b73235340"
    sha256                               x86_64_linux:  "f8db69edf932d25b5459bc5b37fa3bf0f4c3c12148a449eaa5f17fdb3f686c5b"
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