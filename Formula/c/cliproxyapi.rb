class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.23.tar.gz"
  sha256 "f828304f23db0427c4a2928dd8b9d263ee3f27ed55901127e36ef96196e321b5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "460c4ea194293f7d78628b8e82549eb58a347f84faa9177c48c7e55c132a21c0"
    sha256                               arm64_sequoia: "460c4ea194293f7d78628b8e82549eb58a347f84faa9177c48c7e55c132a21c0"
    sha256                               arm64_sonoma:  "460c4ea194293f7d78628b8e82549eb58a347f84faa9177c48c7e55c132a21c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "387c1ab69286aa9e46f8f471077d263fbe1f5439a1c52945d412211c6ba4e70e"
    sha256                               arm64_linux:   "10b57a5ac1b010b4d9f5b5806797b4e96c3d1721de3a12836e5441e5af88b73a"
    sha256                               x86_64_linux:  "07bdf00202790421a3376a83f26429b8f3791e3c3ea68f99a9804ea685e6482e"
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