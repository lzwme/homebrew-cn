class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "2b944e5f2b0a37ec2f7f36c32245620d16f1fae358adb1c65044e90c2b337170"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "ab1964d815a15ba36dc9c775ffdfb45787750a1df1292d299218eb472c37abb9"
    sha256                               arm64_sequoia: "ab1964d815a15ba36dc9c775ffdfb45787750a1df1292d299218eb472c37abb9"
    sha256                               arm64_sonoma:  "ab1964d815a15ba36dc9c775ffdfb45787750a1df1292d299218eb472c37abb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f74ed985481bfad4c28162432aeb3a659234b05b16cd1904c56659b5ad12e446"
    sha256                               arm64_linux:   "3246d855221bd5ffdeaefa54a8f11f3d4e0395fa8cb9fcee274c83c6dd289681"
    sha256                               x86_64_linux:  "7a3d46fde55e8a90c124f7660665aca6c7b89476cb35ce86c0a1ec7e1a2ae3c8"
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