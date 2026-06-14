class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.75.tar.gz"
  sha256 "f29043c2a2a55a1d194f412f267489ab74de76d9e41187fac3f86c44a842640a"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "814a944217b739c63bb9cfd0fbc697e68a7a9897c0b2195d7b95453c9f0eccef"
    sha256 arm64_sequoia: "5a55962030f4920108ac53283befaa99f2e8f91ef649f81fb6feb2ec0ca3cc5d"
    sha256 arm64_sonoma:  "3ad9b12722e4d1e6b8fd9259c9ac0ef7007c5fc644ae37330262643e758e7c0c"
    sha256 sonoma:        "e6873d993abec598f697aed6ae0b0599a67918a1e66da8f2a08807f074c240b7"
    sha256 arm64_linux:   "13acbf27729844f718149e8847a7abc644e3b80722035cfee613f84aee4fe640"
    sha256 x86_64_linux:  "eab9912c89f53cdcd19a3122638ddf8d248a2881e99dd87f775b060f0ca3e5c0"
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