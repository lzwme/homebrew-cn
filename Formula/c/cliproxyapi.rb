class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.8.tar.gz"
  sha256 "59ea7015e131f10139b16bcf47b4066fb1e1d98e988a779a91877869ec3be9a7"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "77069fbbc81fa42589e0ca6022875422fe17ff7ad2bf05f9750f5a045dbce84a"
    sha256 arm64_sequoia: "77069fbbc81fa42589e0ca6022875422fe17ff7ad2bf05f9750f5a045dbce84a"
    sha256 arm64_sonoma:  "77069fbbc81fa42589e0ca6022875422fe17ff7ad2bf05f9750f5a045dbce84a"
    sha256 sonoma:        "a51792c6f9f6548f2cc6e841b839d6a31a7839edd64af9b5d1cf055b45f76ecd"
    sha256 x86_64_linux:  "de8fbaa5238a34fc88ab80d7117c33e54e1e6c54ccf5a95bf10b04b84cb99f6b"
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