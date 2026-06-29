class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.45.tar.gz"
  sha256 "299212b89893cd640b810083281de7f86e4d0363b9f06db4dc6bf258f01adaa4"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "399ccf6a439ab2c26dc572cc2158dded4fb2b09bbb594d22bb9852763ec0db0d"
    sha256 arm64_sequoia: "25ae16b9de324030e53b74f7838b89e7cff7b45edbad45c594e7be5a6011f8b9"
    sha256 arm64_sonoma:  "5fcbe5cda04db642f9eb92a4156ae73c3eb67e4d9ead5587417aaed7dab5cda6"
    sha256 sonoma:        "c2b2457d626b3de99d80ddf1224b005d5f8ade200370bfd186120a1f6bbcbae2"
    sha256 arm64_linux:   "4d185f72c307b96d793ff0c631ae2ea474f8c99d21f73d1a4d778270514dc7c8"
    sha256 x86_64_linux:  "a23013dd318b07fe6f487a2dc6345ad8d044d4152a42c26fe83b90d8117eacb6"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end