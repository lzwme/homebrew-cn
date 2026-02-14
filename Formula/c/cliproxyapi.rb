class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.15.tar.gz"
  sha256 "d336405255651b8500ab28a112aaaea09f3d2cf530f37e644711ad96d17eef06"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "1fe01f9db902758009d40466aa8d1eb7ca41a85fc12b562981d27c300d856d47"
    sha256 arm64_sequoia: "1fe01f9db902758009d40466aa8d1eb7ca41a85fc12b562981d27c300d856d47"
    sha256 arm64_sonoma:  "1fe01f9db902758009d40466aa8d1eb7ca41a85fc12b562981d27c300d856d47"
    sha256 sonoma:        "ee7659f936c8a73182e219c6d33e14068bf9cebc70bbd51706891dde1b554c93"
    sha256 arm64_linux:   "d72f76ddf187237e81cf91deeafbcd5e2da6739b9b098f9112bc9182d1e01cee"
    sha256 x86_64_linux:  "871dd124c40ec82e49a3273853db4aae092c21e18ecbb8971e3bb2a2ed647625"
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