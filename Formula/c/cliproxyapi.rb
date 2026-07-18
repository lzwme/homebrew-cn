class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.85.tar.gz"
  sha256 "aac2819d8b5a7ad25049ffc71ba19198a01d180491af341cd6490ed531567f40"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "3a214466e3e3b9288161a9e45259674629fd406e2c92a3b45886478047d857b2"
    sha256 arm64_sequoia: "ae0012ddefdb359fd1d5dc1fd8fad52b6dffd920a69b920b310c9249853e570e"
    sha256 arm64_sonoma:  "75a84f23c4d5e4bc48d7aa3b8763a58896b8ec2de58abe782f009a746a76adf2"
    sha256 sonoma:        "60243c64fec6ce1b0a7c04ceb4b5b0c99659ab8a86e7f0daab0f13f3a5f7368c"
    sha256 arm64_linux:   "3d020190b4b8a156399ee73d98ca0604f3402df27f1e7f22caf4f0132ac2c3ff"
    sha256 x86_64_linux:  "647815640b1ee1c018ff8aafa63e3fd032da485095249ea95aad269a0cc849d3"
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