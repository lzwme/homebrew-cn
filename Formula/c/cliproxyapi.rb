class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "17e257beb8fb7f895112a28e76ab31a518511e68ed0a96ce43e75675c0283724"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "54a8152dfe704b74679fa9f21f9918e00d6ee3c500676e9775c938be6972f254"
    sha256 arm64_sequoia: "54a8152dfe704b74679fa9f21f9918e00d6ee3c500676e9775c938be6972f254"
    sha256 arm64_sonoma:  "54a8152dfe704b74679fa9f21f9918e00d6ee3c500676e9775c938be6972f254"
    sha256 sonoma:        "5d6a820fb63eb65ad66be567498bb3557c5691dc9d4490a91cdfd9d411eacfea"
    sha256 arm64_linux:   "bc89dc1f1ed573cefb533109b2f62ead77d7b1bc798673f050c84b3fb900f8dd"
    sha256 x86_64_linux:  "911903f0b7744ddba68fbd4684aa65c0c9f13001bc280400d3b0ca25123925ea"
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