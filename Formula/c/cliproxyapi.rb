class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.35.tar.gz"
  sha256 "9593cbe6f57cf50fd4666684f0024fcca1af455e6dbf8359d2bc20220a26c50e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ab4fbb09b8de8d2705c58548bdabdfa101da027f93f517f6050048ad2cfc6b7a"
    sha256                               arm64_sequoia: "ab4fbb09b8de8d2705c58548bdabdfa101da027f93f517f6050048ad2cfc6b7a"
    sha256                               arm64_sonoma:  "ab4fbb09b8de8d2705c58548bdabdfa101da027f93f517f6050048ad2cfc6b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a25962798718b5c2d917bf6920b6d5e9b999e58867714765432c71032db4b47e"
    sha256                               arm64_linux:   "cb17a355146df6dcd989dc700f166bcacee93223f16bc24cf2ebe91ddf62a785"
    sha256                               x86_64_linux:  "e17f9a7d28152b711f91470d46457ff9635954dee041d852c19db9567885bb65"
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