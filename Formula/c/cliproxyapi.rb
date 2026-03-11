class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.50.tar.gz"
  sha256 "14a4b548cc645d77b63daa20a4fd8fc3b1944382ee277a49610d2402fc4e7181"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "bb88e1ed4b545cb159ca1e160e00c17b405ded44f021fc56735d4416dc4d60d7"
    sha256 arm64_sequoia: "bb88e1ed4b545cb159ca1e160e00c17b405ded44f021fc56735d4416dc4d60d7"
    sha256 arm64_sonoma:  "bb88e1ed4b545cb159ca1e160e00c17b405ded44f021fc56735d4416dc4d60d7"
    sha256 sonoma:        "319c1cf27d9ed11393eaae2a50e7ebec19acedc8ad9f3e0a6bc302e1ba824509"
    sha256 arm64_linux:   "d94a23a4919c96f1adec2c2464b19e6ec9f0c5ac1499c28a53be528e7a32203e"
    sha256 x86_64_linux:  "f6871098c8df5724f72e27b52ce589b076757e831f31cc38a19bf4b215818519"
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