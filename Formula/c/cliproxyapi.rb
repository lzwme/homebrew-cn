class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.5.tar.gz"
  sha256 "bdf72cc1af3a8a382b01ff9bc3879465b0410e868fa752dc1dc3d9e975e778f2"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "f6533914a5c31fbefaac68adba77ba40156dabc4a20e11095e45775e6396199a"
    sha256 arm64_sequoia: "f6533914a5c31fbefaac68adba77ba40156dabc4a20e11095e45775e6396199a"
    sha256 arm64_sonoma:  "f6533914a5c31fbefaac68adba77ba40156dabc4a20e11095e45775e6396199a"
    sha256 sonoma:        "3493d27cf9aea52809491ba9682a143d5e5f04aa81de0c8701ac6babba8c4ce9"
    sha256 arm64_linux:   "ec3d969b24b6c2948e8bff3690153a9004262c0d758d14d265761b2662624295"
    sha256 x86_64_linux:  "8d19c23adf8bc5bd6e5c7990e38b7dd5446b2702cb8f08c2f5a2c0eda608f057"
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