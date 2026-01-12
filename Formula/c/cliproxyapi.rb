class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.100.tar.gz"
  sha256 "bfe78fd656f8a97108b49d6adcbb075d816c71ed32c3d2d28c9f4e72448fe7dd"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "68ef87457cc31d2b7d9af86ce5ab19f097f12858ac2de2b0db9426a45187e4db"
    sha256                               arm64_sequoia: "68ef87457cc31d2b7d9af86ce5ab19f097f12858ac2de2b0db9426a45187e4db"
    sha256                               arm64_sonoma:  "68ef87457cc31d2b7d9af86ce5ab19f097f12858ac2de2b0db9426a45187e4db"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5504f2a18066b6b355db5b9d232c2dc62bbc65aecafc8df541b4b1fc3e1ce3d"
    sha256                               arm64_linux:   "30a6abcc82fecf57d44d341ad375b0ccc9faa5b6f17d594cd276cafde9d477a0"
    sha256                               x86_64_linux:  "a43820431999222316b6bce0ccc194973832e6030fc9bd0c6c5356fdbeefacd0"
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