class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.52.tar.gz"
  sha256 "bf4a973f737f187f5deb4bd68d98dbf81ed7bd7c5dd32244831cb5779ff4bc09"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c72e05680438ce50abfd3df2737cb5736a0000f22139a30f0d17ab3d00014888"
    sha256                               arm64_sequoia: "c72e05680438ce50abfd3df2737cb5736a0000f22139a30f0d17ab3d00014888"
    sha256                               arm64_sonoma:  "c72e05680438ce50abfd3df2737cb5736a0000f22139a30f0d17ab3d00014888"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2139b8be8cebdf078af06e880cc60d99a9185b089d768564022eeddacf845ff"
    sha256                               arm64_linux:   "ce032c4fc34d9a5ef30ac0f66960f7f589b66d1c1e971ed708ebd503fc8167f7"
    sha256                               x86_64_linux:  "c037fbd0a3c64992b89a94cd8ebad163356ce1bbec60b37b363e288dead8cd7e"
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