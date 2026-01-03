class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.80.tar.gz"
  sha256 "7f6e528411b1745cd89eb1596df03c727e8cab6ab27b30ec53b2c0747d769009"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "75173d25584901c915cfdbeae45f59a2652bda0ccbd2082ab8f94051e760bcd9"
    sha256                               arm64_sequoia: "75173d25584901c915cfdbeae45f59a2652bda0ccbd2082ab8f94051e760bcd9"
    sha256                               arm64_sonoma:  "75173d25584901c915cfdbeae45f59a2652bda0ccbd2082ab8f94051e760bcd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "514ee171ad52b8232904f52c31d949504f83da55c53e2e23d55be828f3fad3ce"
    sha256                               arm64_linux:   "fb91343d9425a05e366a00593deb752a3de79e48cea48fc42ae3868d5259d763"
    sha256                               x86_64_linux:  "8c0cfca907419eae39ec5e9588beb24da2e0c5ddbf6c1b2de4e7dac0ae245324"
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