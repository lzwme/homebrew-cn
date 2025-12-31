class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.70.tar.gz"
  sha256 "4fef187a4e35569241877b665f5c5e5683bfc51f36d9e2b4508816551d2ec0b4"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "5ad1f58b1b97660d4d13f68376e393eeffad44b905de4db6e1eb3b67c98d8d65"
    sha256                               arm64_sequoia: "5ad1f58b1b97660d4d13f68376e393eeffad44b905de4db6e1eb3b67c98d8d65"
    sha256                               arm64_sonoma:  "5ad1f58b1b97660d4d13f68376e393eeffad44b905de4db6e1eb3b67c98d8d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "656f506502838b308ce4fed7f8bf2d54349eb649700874b40b53ee094192951e"
    sha256                               arm64_linux:   "c49d500a9a86b5409fae7cb0b1c08e2bc96e92a500d20898f1f762bc82436704"
    sha256                               x86_64_linux:  "70256b613b9c20fca3d67b7fa1f136828eac25efad3ddcbba3178446a53e152f"
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