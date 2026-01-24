class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.20.tar.gz"
  sha256 "e9eeb4d4a6ce80f93ace690668bf5d7e05e009b5f9279fdfa29e088b49ce1c54"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "745c72782bd5958bdfc811187fe043d13e5151c8f97d9a5b446c731be073bf70"
    sha256                               arm64_sequoia: "745c72782bd5958bdfc811187fe043d13e5151c8f97d9a5b446c731be073bf70"
    sha256                               arm64_sonoma:  "745c72782bd5958bdfc811187fe043d13e5151c8f97d9a5b446c731be073bf70"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a3cb2b3128b0e239048fa36ed0d6355a867cfa1c00f9861278f0c2f67572e9"
    sha256                               arm64_linux:   "61cc158d73b61c5c6f7370144bdb663c88a3640d3dd1783fad069d31753f1353"
    sha256                               x86_64_linux:  "0c05232a24af0cf7e547d3428c59121a30ffbaf3c25576c461715d2d97893939"
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