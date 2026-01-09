class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.90.tar.gz"
  sha256 "55afa76a3eed6b03443fa4bb3c927b6838365059061f45b8fdba5ee02a3df277"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "a46baa12570e73080e83e2a6911d2f14bcd0d269e4872017f7079811029a0a23"
    sha256                               arm64_sequoia: "a46baa12570e73080e83e2a6911d2f14bcd0d269e4872017f7079811029a0a23"
    sha256                               arm64_sonoma:  "a46baa12570e73080e83e2a6911d2f14bcd0d269e4872017f7079811029a0a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "053b90d0eadcefd63dd58d060ad0e771d7280599d3f493bd5d8b74c0c9a988e1"
    sha256                               arm64_linux:   "2ed73063f0df06fc9ef8b9be5867213852be42ab0107ebac8d93f3222c5def87"
    sha256                               x86_64_linux:  "a333faf8f1dac47e22e6b0336b7b57e2f11ae79e21a0f49d67cd358449dd94e2"
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