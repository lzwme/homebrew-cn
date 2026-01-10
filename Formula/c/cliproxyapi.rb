class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.95.tar.gz"
  sha256 "19a0b75d1d0baac9550734fbbd4cadabb57575a9f4c62b59af981a768a5a4487"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "f8831e45592a65774652a7496aac7fc556953e5dbc3e2ab272055c7b12cc2bb6"
    sha256                               arm64_sequoia: "f8831e45592a65774652a7496aac7fc556953e5dbc3e2ab272055c7b12cc2bb6"
    sha256                               arm64_sonoma:  "f8831e45592a65774652a7496aac7fc556953e5dbc3e2ab272055c7b12cc2bb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5af6b6af56619f70d881915a7aebc24204a437470e4cbee17b0a8d1573311dd"
    sha256                               arm64_linux:   "3c913452dfc2114c5deb86be1d1c7b1e5746142d57c8549ac8f44e20d091eb9e"
    sha256                               x86_64_linux:  "3c1d15e6da47c8f9fc782033cada6bff6992c45115e0879a4463c3024daf64a3"
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