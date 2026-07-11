class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.65.tar.gz"
  sha256 "124403445a5d9a09448ae102d9c332275dae57f2b3978e9c5971b130aa8acc81"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "1f6e68229cf3a5b5365b022eaf7817a248d4e3346edccb44782dbe4837e2dcde"
    sha256 arm64_sequoia: "4c7c5c529e215cec66ec8fa0472584d6905226f56a4ca12bb07afd951e475ae3"
    sha256 arm64_sonoma:  "8ab7db58b4cdfe79ffa9d2a91bba9fc6ef2e3028d2b24365231165859c01ed86"
    sha256 sonoma:        "ef0b370e479b6e0169ca2a4b152e0d96ab0f85a420153d0ac737f5f57a76a9ff"
    sha256 arm64_linux:   "704d017c48734f44fd2251bbb2c12267ba3b8333b7261a82a18d8bf30c2271c0"
    sha256 x86_64_linux:  "a9f8ba9292e2c5bea1928d3a56425bc5ecaa170af3e42bf7f45bf1eb761c65e7"
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