class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.29.tar.gz"
  sha256 "6248ecc5b4bc1ee898f045734aa7345371fea98b36410d878ef24cba8d5bd63c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "28d60b1a3c99a8c6b70273704cce9b1d81ef30a9fef0c706225af8d323de74a8"
    sha256                               arm64_sequoia: "28d60b1a3c99a8c6b70273704cce9b1d81ef30a9fef0c706225af8d323de74a8"
    sha256                               arm64_sonoma:  "28d60b1a3c99a8c6b70273704cce9b1d81ef30a9fef0c706225af8d323de74a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f500997048ca1c617846928b0d353eba98bcf49b8ac676d21c0c73cfb04e081"
    sha256                               arm64_linux:   "77615e561b1a1ca768d8a7f75cd289371cf62f780f227343973e547f405e1cd8"
    sha256                               x86_64_linux:  "b53cd7de7d4bdeffdc75f94b6fc81a4d3fac2435dc0da870b47327da8ca1f60c"
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