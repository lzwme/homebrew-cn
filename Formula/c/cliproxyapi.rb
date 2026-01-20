class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.10.tar.gz"
  sha256 "e48d9409ab3f640ed73cc7a1bb10fd4f5960ddb765d2372537505053144df9ea"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "86fde105cfbbd9947c83e1d529f472c7c4537d4664742a4f428c7282dfab6e84"
    sha256                               arm64_sequoia: "86fde105cfbbd9947c83e1d529f472c7c4537d4664742a4f428c7282dfab6e84"
    sha256                               arm64_sonoma:  "86fde105cfbbd9947c83e1d529f472c7c4537d4664742a4f428c7282dfab6e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e665165aababbccf6109d6dbd2d063445a731538f6b8c678e91d74865e6ef1"
    sha256                               arm64_linux:   "8216540a6ac717656a2b35e95b5bc5459fb0583204106e64631802f49b39e264"
    sha256                               x86_64_linux:  "dd3557c57bc1618ea4401a15c1d9aff820eed18b20f19dc5bc7b33c5cfef63ed"
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