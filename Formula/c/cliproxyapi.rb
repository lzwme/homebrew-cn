class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "3037213c4d27294992b25b8ed73a7718dc877c0e05bc5fe7938710d75ab488eb"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "473066b746349d8349539e50a3dee77ed7b8a271579772620b5f79523dfff4de"
    sha256 arm64_sequoia: "473066b746349d8349539e50a3dee77ed7b8a271579772620b5f79523dfff4de"
    sha256 arm64_sonoma:  "473066b746349d8349539e50a3dee77ed7b8a271579772620b5f79523dfff4de"
    sha256 sonoma:        "995fc57a21683ec9ccc085297808e42bd5fa83f7905ef90a4c5f090421c85284"
    sha256 arm64_linux:   "83cf1726724f2401d5c7c399c7b01c6e0e31827750432e542da227423bd5136a"
    sha256 x86_64_linux:  "e83e5c351690f44f500b93aa0d1c70c16e2395c9eb94c7de377da715fce0f3f6"
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