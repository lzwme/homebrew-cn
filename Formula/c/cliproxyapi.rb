class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.31.tar.gz"
  sha256 "62ad527ba3856e86d930894fb288eb86550bef8ac4628b4b477bf44d26ac4e9e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3edb4db4f0bcf5d10804013a231fa1657c41ad60f9599068c09b74e8786582c3"
    sha256                               arm64_sequoia: "3edb4db4f0bcf5d10804013a231fa1657c41ad60f9599068c09b74e8786582c3"
    sha256                               arm64_sonoma:  "3edb4db4f0bcf5d10804013a231fa1657c41ad60f9599068c09b74e8786582c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a61afb470a3626c43973b06ac247a7d6ddf041bc905d6552fed4dd55d4c9f9c2"
    sha256                               arm64_linux:   "9c413c1f5467b486f1492319c1470a081d07fa6fb37628aea5c5e2d48f31ac39"
    sha256                               x86_64_linux:  "a6cf79d5fe3b025fe3e5ab1fcb977f8760b2d34d1777f5a914bba29477fcba0c"
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