class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.25.tar.gz"
  sha256 "1bd015c189ebb58040c486465d15feb8ce9497bbf20c6eac8adb9426c997c0f6"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "d1c245883a86ae32d23b9fc7bc4a7310b31ba0797c41fc96447c156b8fee39aa"
    sha256                               arm64_sequoia: "d1c245883a86ae32d23b9fc7bc4a7310b31ba0797c41fc96447c156b8fee39aa"
    sha256                               arm64_sonoma:  "d1c245883a86ae32d23b9fc7bc4a7310b31ba0797c41fc96447c156b8fee39aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "423ddfe937370cbb4ed705211affea203101a378d4abd105de55f68e8f83d845"
    sha256                               arm64_linux:   "1f02641a784c7abacc26dea2ea2a5ce874ba2697f61139712896d4a1599b2542"
    sha256                               x86_64_linux:  "17831230207998571ebc82d8e8986212ec15ee264a9a20cb6722e997095888f8"
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