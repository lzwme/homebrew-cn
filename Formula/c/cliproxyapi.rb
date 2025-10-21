class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.25.tar.gz"
  sha256 "0a904cd044cb32468d07e41bc8933433b5fadb40360582540ce18e32cc1574f0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2a9f5fc154da8db65374e5da9599a981d578e96a01a99c04bb6ea08b464696d3"
    sha256                               arm64_sequoia: "2a9f5fc154da8db65374e5da9599a981d578e96a01a99c04bb6ea08b464696d3"
    sha256                               arm64_sonoma:  "2a9f5fc154da8db65374e5da9599a981d578e96a01a99c04bb6ea08b464696d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c81b3b80054c6d30ed19c3db7486612e166ebd833b5ecd906e92ec1a1b406e8"
    sha256                               arm64_linux:   "94c3477cd2f653759f2b5aabcf0f20235c21ecebd97a4736cd10f25a18c138c1"
    sha256                               x86_64_linux:  "8bdb6534e4749725ac88408dab94424c2187bb0bcbf344574656b3625ec0774d"
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