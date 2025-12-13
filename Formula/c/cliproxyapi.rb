class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.8.tar.gz"
  sha256 "19d4eb4f1cdc485986c43fcddeb695b4f200cdd398519a1e56de850c790bf070"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3e40a6804eb5434bb35274ed6ed3f1042de76346f447b5959cfdb14ab88b1872"
    sha256                               arm64_sequoia: "3e40a6804eb5434bb35274ed6ed3f1042de76346f447b5959cfdb14ab88b1872"
    sha256                               arm64_sonoma:  "3e40a6804eb5434bb35274ed6ed3f1042de76346f447b5959cfdb14ab88b1872"
    sha256 cellar: :any_skip_relocation, sonoma:        "50d9d88c408f491261e441436435de41cac1ba1ea781c01a39fece69368ebad8"
    sha256                               arm64_linux:   "18108b49c120e206c8d1cb432ca4922ce1125b2082cd076395979df668c65559"
    sha256                               x86_64_linux:  "2dc307da98151772b14ca41b905a9af7d4ff41eaa16de9a3e28ff6ca8e6befc6"
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