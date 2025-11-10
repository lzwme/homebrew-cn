class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.25.tar.gz"
  sha256 "e2a3b7828bbf2cfa8c0b99a9a0e7c007e0fead23e36eb0c36c07521643746833"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4e51bda7f51bac7751cec639d0f6d261a1404b0646b2945c19dbb2382887b4cc"
    sha256                               arm64_sequoia: "4e51bda7f51bac7751cec639d0f6d261a1404b0646b2945c19dbb2382887b4cc"
    sha256                               arm64_sonoma:  "4e51bda7f51bac7751cec639d0f6d261a1404b0646b2945c19dbb2382887b4cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd514e311a88cac6bdab736c91d6974d6789821d7f3d33cfe74693de44396487"
    sha256                               arm64_linux:   "404c03799896cb44c0e6975682f90618f9f009d31046e625e7b4343314d5fbc1"
    sha256                               x86_64_linux:  "ccc599da3c2b9b000645be1e46133e0597a69bcfbce266c0ace65ca09cbf6d9a"
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