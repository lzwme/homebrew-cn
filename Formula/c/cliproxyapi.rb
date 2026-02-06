class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.50.tar.gz"
  sha256 "a089bdb916699c6aa6991587f8c03dbfd5bfe291f5ba0de99474ef6906918109"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "b2621326b1faf8f31e412a8bd84103de7f8ea3256d4ec71e84f3f7d80992ea66"
    sha256                               arm64_sequoia: "b2621326b1faf8f31e412a8bd84103de7f8ea3256d4ec71e84f3f7d80992ea66"
    sha256                               arm64_sonoma:  "b2621326b1faf8f31e412a8bd84103de7f8ea3256d4ec71e84f3f7d80992ea66"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d13010b46b89f58abb65f2530d03495f059337aad8020daf85e55e5c60ffbb"
    sha256                               arm64_linux:   "cdc0c32a1e160ca8c6bc2eceaf80793ed874dbce25a0dc447e17f6645c048196"
    sha256                               x86_64_linux:  "da8e283729c4655f8971bc5a1d62dff57c0169aeb2238e2c2015908e72b7c39d"
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