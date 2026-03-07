class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.45.tar.gz"
  sha256 "3019c549cf85f1964998c4a7933ffafea0b293ea060f29427b3381480fb82b9d"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "651f39685157c3524413f88c3e254c25aaca904a7de5fe4825942291700a9e42"
    sha256 arm64_sequoia: "651f39685157c3524413f88c3e254c25aaca904a7de5fe4825942291700a9e42"
    sha256 arm64_sonoma:  "651f39685157c3524413f88c3e254c25aaca904a7de5fe4825942291700a9e42"
    sha256 sonoma:        "40f16425fe68ab9506a777e544a99f1748178d5a35850fb276480c287f7c0a5f"
    sha256 arm64_linux:   "695640751b7b03814a65975bd162a9441dd6f384f9b5553b16bfbc9733b482fa"
    sha256 x86_64_linux:  "e6d9871a17ed12d02a23cc7e024d8dd5c00d664911b37a198d6dc16ad0c95f7f"
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