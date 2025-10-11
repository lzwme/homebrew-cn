class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.17.tar.gz"
  sha256 "671fe33a82e7b682384028eb349e78932f0eb8456198a287be85e466275e76f9"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "afcb41a4a3d39192ff757d2ad0fc6bb4ea581e77d400e2079daa2ac073857dfa"
    sha256 arm64_sequoia: "afcb41a4a3d39192ff757d2ad0fc6bb4ea581e77d400e2079daa2ac073857dfa"
    sha256 arm64_sonoma:  "afcb41a4a3d39192ff757d2ad0fc6bb4ea581e77d400e2079daa2ac073857dfa"
    sha256 sonoma:        "dc820120fd1db07ee0d8eafcaf3329af662a7aa71a6b93b225dccc5539ef6cee"
    sha256 arm64_linux:   "b5081dbc6310eb0b7d1c2e10c74c6d66275641a15909f496fbd4e5a703f304bb"
    sha256 x86_64_linux:  "be0162bfb6e82c87a9436404733ed841293cdc3df0370ea60a7e1bea7bb83dd2"
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