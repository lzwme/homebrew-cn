class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.33.tar.gz"
  sha256 "6c9c814dd68cc810126f6733eaa31ab8f3c5f902193bf75512165ac46a12cd22"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ceb6bced1e6a4ec887a60e97718bbec1b927f3ab756bb1e271b85b9f760aac6d"
    sha256                               arm64_sequoia: "ceb6bced1e6a4ec887a60e97718bbec1b927f3ab756bb1e271b85b9f760aac6d"
    sha256                               arm64_sonoma:  "ceb6bced1e6a4ec887a60e97718bbec1b927f3ab756bb1e271b85b9f760aac6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55919a3eb68d5e09b04c561b9e4f57f3359458c538bbcdd9e25f31adb39783e"
    sha256                               arm64_linux:   "00ee28deb1be080aebe5bea704da47a0878613dd67e16d1565622cf52d27d537"
    sha256                               x86_64_linux:  "4ae6be7543cc33bb3a1a123d5dc40f983fb69408e8e3fb39bb301c78a531406d"
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