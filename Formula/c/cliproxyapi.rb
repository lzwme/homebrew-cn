class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.24.tar.gz"
  sha256 "bef83f30742238c28fe4044ab6b82c035aaa3bb807e99ea15fee8e063a1f43f5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0942dd7f22107ec436eaebcf7c098a77c34ce510651e9bab25a2d149ca1ce4f3"
    sha256                               arm64_sequoia: "0942dd7f22107ec436eaebcf7c098a77c34ce510651e9bab25a2d149ca1ce4f3"
    sha256                               arm64_sonoma:  "0942dd7f22107ec436eaebcf7c098a77c34ce510651e9bab25a2d149ca1ce4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f86aff375f58e65fbe4ad282b54e0ca32a8d436023d35d508a51de5d8e88934"
    sha256                               arm64_linux:   "40abac0e48f37deaf9308e4b857f158de755eebc421a47bd89856746368750bf"
    sha256                               x86_64_linux:  "4ffa1ee59bdf0d35767d01e49d9fc3f7353aad11e7955a2a9f8420aec3f8d02a"
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