class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.55.tar.gz"
  sha256 "3d5835825b7726c0bca43c4ee5678ce3d46455208619c84693d9f9664763206f"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "48dc3959261be69dee930ba4c4a3f135b60268060af629b2d430fce03bb7ae85"
    sha256                               arm64_sequoia: "48dc3959261be69dee930ba4c4a3f135b60268060af629b2d430fce03bb7ae85"
    sha256                               arm64_sonoma:  "48dc3959261be69dee930ba4c4a3f135b60268060af629b2d430fce03bb7ae85"
    sha256 cellar: :any_skip_relocation, sonoma:        "40732940765016aabc1e42550e265b70fd69acc2bb2d25ac986012c5962d5b87"
    sha256                               arm64_linux:   "1ed1da4c60012a6b2e4289c5f1cf35222b452e5971fa8fa8ab888d1a07244c84"
    sha256                               x86_64_linux:  "6ee231f24432df8191ff94b2ded4da2e7ca8208d2092187c4e683898773799bf"
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