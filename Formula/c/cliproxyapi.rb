class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.6.tar.gz"
  sha256 "69006595d310a9bd98f07e44141bd8103f036ac223915fc2afbdf9a069631a38"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "df94a3b512023ff7edd090711e892509e1d98edaae4b2243fe63a9e3df7fbfe1"
    sha256                               arm64_sequoia: "df94a3b512023ff7edd090711e892509e1d98edaae4b2243fe63a9e3df7fbfe1"
    sha256                               arm64_sonoma:  "df94a3b512023ff7edd090711e892509e1d98edaae4b2243fe63a9e3df7fbfe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6321daab505512812d6e0e53ee8b5475e9fab4251fbe4d1f5832f22b4b3a1cf"
    sha256                               arm64_linux:   "4a4a59e8800568147355fe4f556ebbb55fca834b1e422e77424a2e33a421c9fe"
    sha256                               x86_64_linux:  "ad8e0d023e0d8353e85c46c81da3765ac3b468e35784eb39a8831b01c594f88c"
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