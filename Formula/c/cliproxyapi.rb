class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.0.tar.gz"
  sha256 "d615bd79c2930f4140c29f177aa26d953e9ee4e80ca8cae7994c12f7cc548698"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cdb05462a346abc1fa2268b3a6de326cb58b5b214202ee21ea368c775c31c0cd"
    sha256                               arm64_sequoia: "cdb05462a346abc1fa2268b3a6de326cb58b5b214202ee21ea368c775c31c0cd"
    sha256                               arm64_sonoma:  "cdb05462a346abc1fa2268b3a6de326cb58b5b214202ee21ea368c775c31c0cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e4eda5bb79a01ab4da08ccae8587cc52fe7bec851d159b6f735292566f1de5"
    sha256                               arm64_linux:   "f4a210dabce63cccf93b00cd3472982f65ba45cce074c06b7dda876720734a6b"
    sha256                               x86_64_linux:  "5ddaebad46add21c0dfac859b63b070e9cbfd2b44549f48e8f92b994c01cd8c0"
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