class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.40.tar.gz"
  sha256 "9c8f2f898f6bcd1f7e7e90fa23f02a1fbb5aacc7a109db8da7bd0f96cd8cbb8b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fd3dbe86881d3339a7fee2188a489a11146d127731f1bf1fc0ca998222515738"
    sha256                               arm64_sequoia: "fd3dbe86881d3339a7fee2188a489a11146d127731f1bf1fc0ca998222515738"
    sha256                               arm64_sonoma:  "fd3dbe86881d3339a7fee2188a489a11146d127731f1bf1fc0ca998222515738"
    sha256 cellar: :any_skip_relocation, sonoma:        "67bfdf359ff51175da4aa5f197c2620b2b6aedd159db2057c82207dfc6ffbdf4"
    sha256                               arm64_linux:   "925ad1c816daae12896c267f99aa768aa3598a2aa97921e75af0173733019c5b"
    sha256                               x86_64_linux:  "9c5c51e45b873901f9ae02f7fa14d506df6b4848cb4424063a4aa4774ceb51a3"
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