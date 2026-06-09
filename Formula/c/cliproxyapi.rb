class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.55.tar.gz"
  sha256 "9196531165b38f10a06d23bc1f744569a2c851874e9252dff4d203e1df608cc0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "7660b514946dcfa81bc6c68ecba23a751b8c59002e2fff7f407dc866166da55e"
    sha256 arm64_sequoia: "0784f809e2ec97b4fa1342156cea2383deeb1ae4da49403f9e9459511cdda6da"
    sha256 arm64_sonoma:  "f1dd4f23219d36992543327dfba52d7cddde4f4ddbd784c224fdcc9036335514"
    sha256 sonoma:        "c155741d0e39b202f7c73281e08d4519f6313b6f9e5f04fe9dcf388bb7275482"
    sha256 arm64_linux:   "b8fa80874b452277b64c630403548325c8b218cf249c85514d6e29d41f7deac7"
    sha256 x86_64_linux:  "b800779fb966adafee728ddf4750b95bd31af3ee3d2102e8de57a3099cefa90d"
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