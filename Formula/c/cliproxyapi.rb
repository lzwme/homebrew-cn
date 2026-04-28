class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.40.tar.gz"
  sha256 "139855549e3dab6fcc99a8b3add8fcdf343f5b87bf04e0411eab34d781e94008"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "20a4dbfc9b125a2a6b41b4cfdcd30366d319227f79131bc449adf238fef7f8dc"
    sha256 arm64_sequoia: "20a4dbfc9b125a2a6b41b4cfdcd30366d319227f79131bc449adf238fef7f8dc"
    sha256 arm64_sonoma:  "20a4dbfc9b125a2a6b41b4cfdcd30366d319227f79131bc449adf238fef7f8dc"
    sha256 sonoma:        "5e81ce263b97b6e8df33a6e53f47266cc220a4ee01eb7a2ee9b5e7256eb3e81b"
    sha256 arm64_linux:   "d6615031955ad2b5e20c114e156e6079806fe3fe92696e92a29759c396e72ab8"
    sha256 x86_64_linux:  "b31dd8cd5fca16a5ebcc69dc709c987ecf6a16475d9c331864e7903c9426e455"
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