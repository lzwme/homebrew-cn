class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.38.tar.gz"
  sha256 "eee046b5635942bd77f1bb1c690639518fbaf14820bc593ea3e260a8b411ea39"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e73e8628102b17f792e11c174a18b9b53eae9d0103c4569d4ec36d72106d2388"
    sha256                               arm64_sequoia: "e73e8628102b17f792e11c174a18b9b53eae9d0103c4569d4ec36d72106d2388"
    sha256                               arm64_sonoma:  "e73e8628102b17f792e11c174a18b9b53eae9d0103c4569d4ec36d72106d2388"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44edd0b3a3987cb74ce643385d3ca07423261ebfc12f8b453e1ef81d7fc73b4"
    sha256                               arm64_linux:   "b1ce666e48533c687fd269be9dfdeada33ea2f6a58f9b1b814275bfccdb00f3e"
    sha256                               x86_64_linux:  "9816e99f87ca8b805848c0a4095c87b78162a8c31ed73e3f6f701b0d98e349e9"
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