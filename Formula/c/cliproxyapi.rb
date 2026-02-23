class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.25.tar.gz"
  sha256 "ef81147f689cd22760a3a6e0ad95b30572e5377747c7161772d53121bac553c9"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "03eef9f470299bece088da243bbfd9d4983d3d79ec1d3a311edebfe67f6fb032"
    sha256 arm64_sequoia: "03eef9f470299bece088da243bbfd9d4983d3d79ec1d3a311edebfe67f6fb032"
    sha256 arm64_sonoma:  "03eef9f470299bece088da243bbfd9d4983d3d79ec1d3a311edebfe67f6fb032"
    sha256 sonoma:        "6f5ead3b7798c89f952d534d12256d1726a3d515a4d49cfa64d3124689617308"
    sha256 arm64_linux:   "97af83de1a7b56e1e2baee7350a6ba69fc86bb64d30f6faa3fa5340046fd2bc9"
    sha256 x86_64_linux:  "adc25b6488e2aba14cf18d036e38f5a4cc923842307779e6a09920c3674aa0f5"
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