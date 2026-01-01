class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.75.tar.gz"
  sha256 "9769764cbc48318eace14e4b746e81fb7330cdd2ccb4185cf61ac3001face955"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "42fadac7ca0a0fa945c549d185059c537ec05e4fa1e2a76283ba8114dfd51ecb"
    sha256                               arm64_sequoia: "42fadac7ca0a0fa945c549d185059c537ec05e4fa1e2a76283ba8114dfd51ecb"
    sha256                               arm64_sonoma:  "42fadac7ca0a0fa945c549d185059c537ec05e4fa1e2a76283ba8114dfd51ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a5a03c4d41d360b8c4414eeace81f958cfb481971ce3a9cdae0329e23057cf"
    sha256                               arm64_linux:   "ee882997d7b7f78b8453678eb266f7e6a42d15c785403304cfe2c8459b851830"
    sha256                               x86_64_linux:  "3d6837dae9a11690aa20a61466da90f7fe07889d0e763254b7dab78a4b0cb14c"
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