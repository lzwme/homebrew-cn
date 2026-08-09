class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.125.tar.gz"
  sha256 "ad9d638ecc3094580fcadc7cd08af69f876eed3f925f7b598c0dcc4e86642700"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "bc6b196cc6f9bc7fde1ad534816f42ba6bd0c8929335dfdaebb84c0a416cbe80"
    sha256 arm64_sequoia: "2d11f5dd70a7944df7df9c4dc6bb0c57a4768445e96dfb2243565c359d9730ef"
    sha256 arm64_sonoma:  "ef5dc84d13044dbb90d9b6adada2b04320ed9e77318cf0f301289422c3f999f1"
    sha256 sonoma:        "04eb14f685e7d92913828c1fd3f7b5a477499d756e0e1e9529db8c47af047bca"
    sha256 arm64_linux:   "cb9af16ad0d1bc9b1393cd2ad016ae9bd88a1c70a2b355bc16b290d7a8dd691a"
    sha256 x86_64_linux:  "c66344943c85df3c0258060e390b6ff1b63aaa9ef4831f9a886e063f504b3d3b"
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