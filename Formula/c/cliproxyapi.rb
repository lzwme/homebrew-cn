class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.30.tar.gz"
  sha256 "ef899d25c098a5745109f3cdd43702dda2451066aa34d3e063b0285ce97e5698"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "32d9a73bdd67ef6ea9d977cc2b9bb9477566d4a41ba8aad48c563c1847e5d693"
    sha256 arm64_sequoia: "32d9a73bdd67ef6ea9d977cc2b9bb9477566d4a41ba8aad48c563c1847e5d693"
    sha256 arm64_sonoma:  "32d9a73bdd67ef6ea9d977cc2b9bb9477566d4a41ba8aad48c563c1847e5d693"
    sha256 sonoma:        "ce17e5740b55a213a0219fa2c8396b2b1688e1269def0dfe0292f0df7e3e3baa"
    sha256 arm64_linux:   "4adbd32ae7eb0d05b7ee91111b463f83665d26d6c184d4e872d551cd47a43aeb"
    sha256 x86_64_linux:  "895466ac25fd6d8c63836850b011da5e5dfb062089e19028dade6e0f605c5fea"
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