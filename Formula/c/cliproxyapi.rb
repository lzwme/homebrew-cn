class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.10.tar.gz"
  sha256 "837d0cb62b44bba8922dc2768b6c145e48a370bbdf032e8dc3c253fa8600e341"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "201ff2f9680e97861d09005ffc94ae9ccc677c64c584d2aba6d3375e61a41131"
    sha256                               arm64_sequoia: "201ff2f9680e97861d09005ffc94ae9ccc677c64c584d2aba6d3375e61a41131"
    sha256                               arm64_sonoma:  "201ff2f9680e97861d09005ffc94ae9ccc677c64c584d2aba6d3375e61a41131"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c73d426fb40c5a117cee73a9056ed38e91bb722dcdc26474c494a22e909c3d"
    sha256                               arm64_linux:   "63e3d9f52168e72d35619b9f5c558fe13eac0fb4e0085c2a2709b17d00da8cdc"
    sha256                               x86_64_linux:  "4eb8c958442619ca657f11e6d6e40c67ae4e0fd8665e3328fa91e13ad2edadd5"
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