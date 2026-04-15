class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.25.tar.gz"
  sha256 "e323817481f5afa20733f52047b072e994c8043c0adaf5628e42c5ddef09d173"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "37ab1ae5bccd4e11ab64daee2b6834eea2e9db2a4eec0d1b5f55044d8d3e3ba4"
    sha256 arm64_sequoia: "37ab1ae5bccd4e11ab64daee2b6834eea2e9db2a4eec0d1b5f55044d8d3e3ba4"
    sha256 arm64_sonoma:  "37ab1ae5bccd4e11ab64daee2b6834eea2e9db2a4eec0d1b5f55044d8d3e3ba4"
    sha256 sonoma:        "c48312b5667a61f8b33b83290ed9b0a12c9230017eaad168ecf3e1a145ead7a9"
    sha256 arm64_linux:   "93e747770fed88736bae1ae0b814da76012945338fbfb8992bf33ac5c1780b18"
    sha256 x86_64_linux:  "a553c9f3b2735ec6dca0b3a7932d9907acac2a9ef693aa8af835121bd01b47eb"
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