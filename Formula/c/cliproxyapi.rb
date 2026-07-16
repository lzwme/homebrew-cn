class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.80.tar.gz"
  sha256 "43ddf12bfb78ddf8aa3b17e7002f42d8358de6b704f706c01d01e7e2d9a732ae"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "3548694d865d95ff6db894a05e32c4aa61ddd679167d2cd38d7b09637f0da60a"
    sha256 arm64_sequoia: "f197210af6b5a2deaf00293eb9b043cb1c9b503a9942bcfdcd0721ec7f745770"
    sha256 arm64_sonoma:  "2439bc34f8cf276830091b5fa470600384aa8c329354aefbed99b465ed3f549c"
    sha256 sonoma:        "40939f665b305fa3ad4a1e74f191875ce22b57c54d0e2798daf35cc6c3639621"
    sha256 arm64_linux:   "077485cbc0920ad11c329286f032fa40aaa47fc35e255fe487d55b7dea1728e7"
    sha256 x86_64_linux:  "699170131eb141cdd94b95437253e925b920ec7fae7706350336e286982bf7e3"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end