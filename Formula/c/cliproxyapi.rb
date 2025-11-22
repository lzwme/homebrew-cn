class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.4.tar.gz"
  sha256 "21407dd51872c46f66f778715e679d76ce26ef1ecf86ba7a6dd54f0a6c3c0450"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8161365812c4edd758db38d617dd01cff40fed36666a8f52d0ff084ad94b7536"
    sha256                               arm64_sequoia: "8161365812c4edd758db38d617dd01cff40fed36666a8f52d0ff084ad94b7536"
    sha256                               arm64_sonoma:  "8161365812c4edd758db38d617dd01cff40fed36666a8f52d0ff084ad94b7536"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e7c38d67ec9cdcce322e7665b5ebdbc430e4707208612b17183c0f9361e12a6"
    sha256                               arm64_linux:   "d9a25ff6a1a6fc3d92f21c8a83883242fc6fec4a9b9c4b32188b3e581b03e45f"
    sha256                               x86_64_linux:  "402587df8b4f40cfa68fa04f4d18004ea847bf4d496f1d733fff8d93c25e32d5"
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