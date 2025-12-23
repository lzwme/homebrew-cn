class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.46.tar.gz"
  sha256 "78c354766eecd1aaae780ee18de32aa6bdb26f58d1e3a2fd2aeba0c000844b31"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0096a6f3d37f0453b6c905ac58703c76070f392a5efe072be5f9bbb8b65d6ecc"
    sha256                               arm64_sequoia: "0096a6f3d37f0453b6c905ac58703c76070f392a5efe072be5f9bbb8b65d6ecc"
    sha256                               arm64_sonoma:  "0096a6f3d37f0453b6c905ac58703c76070f392a5efe072be5f9bbb8b65d6ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "944da013cd3ae58c3d6e8ee65e71cb3a4d3cfa4033d16b7ffa42869fb372b9f5"
    sha256                               arm64_linux:   "a77e59bdb8c20d19ec044f4a014465bbef7f369d7439bb5918a0ce43d1670796"
    sha256                               x86_64_linux:  "ca33c94c53196bfc42d3ab73ca453798da227d699dd2468a156729e33cc6f93d"
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