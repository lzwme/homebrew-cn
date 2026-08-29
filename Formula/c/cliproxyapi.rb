class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.145.tar.gz"
  sha256 "0a6015ae9511f6e10307ef3cea1bf86b703f418ba74182e523639c9871af0eae"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "a33afe7056eeeffdd16a9b84f66a03b17cd9f8f4219d62014f67197b3e94ce84"
    sha256 arm64_sequoia: "46c196013e8c260f56ba6ee5f6035e83764a94e0a3c8c0f546787f4f08f2b9b6"
    sha256 arm64_sonoma:  "870bf0aa210c5028128e241c60ee27618792981e756a6b64cf50eedd830648f4"
    sha256 arm64_linux:   "d62f2766a0c649c69f2b336a58572063d1e1c17df39be5142077ea9d6fe6e1a0"
    sha256 x86_64_linux:  "2a12ca0ad430d50987a5f84e888d6851934ae51c239ba2509c1e6390c37abfde"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end