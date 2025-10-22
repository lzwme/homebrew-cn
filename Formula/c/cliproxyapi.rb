class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.28.tar.gz"
  sha256 "cd73f9153f87e7c2cad1a3b0d06c54ac436d633405a9e04a230b006bbe03946e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "79065f09d660e1931347d89e6b97b79139c946920a1e24ccebc2650a440abd8a"
    sha256                               arm64_sequoia: "79065f09d660e1931347d89e6b97b79139c946920a1e24ccebc2650a440abd8a"
    sha256                               arm64_sonoma:  "79065f09d660e1931347d89e6b97b79139c946920a1e24ccebc2650a440abd8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d00cbf4321c9b698b411c25b23920f84686f2df0bac45041088c7b990aec5fa"
    sha256                               arm64_linux:   "508c235d9dc9259b2a2290e9c8bfb5998ea250d02bfeb66d14b5b9bbaf5baf02"
    sha256                               x86_64_linux:  "5a1fd67b6afb208da97c04095c9633ef71f781dfe70b1faa2fe0644e0a2cd589"
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