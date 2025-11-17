class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.49.tar.gz"
  sha256 "4e1d8eb10fcebd1494586fa82b58281199d0907208d324592160de67803aab01"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e66089879ef9dd7dfa875bc320ead11d18c84fc2d7925583f99c6a19335919aa"
    sha256                               arm64_sequoia: "e66089879ef9dd7dfa875bc320ead11d18c84fc2d7925583f99c6a19335919aa"
    sha256                               arm64_sonoma:  "e66089879ef9dd7dfa875bc320ead11d18c84fc2d7925583f99c6a19335919aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6085e9bcf484ad0e8edde2c762766d6385785d6e515022cb81113ffd7ed77892"
    sha256                               arm64_linux:   "1b46cdd65f756123c99867d0002f2af58f7c964b75c52509259c2d2d88a26f1c"
    sha256                               x86_64_linux:  "ad1ccccfc56d7108037dca830733ef77b98e74af5c308c5357fc70fbc1ee2bad"
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