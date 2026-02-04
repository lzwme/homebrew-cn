class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.45.tar.gz"
  sha256 "9d4710686c14afe5add2e16627629e149dbc5b4ef2769c61368496a510407be1"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "cfd413411e94a5e4e6bca0731216b93d346b1dfad02d75b7f08161e7c45d44aa"
    sha256                               arm64_sequoia: "cfd413411e94a5e4e6bca0731216b93d346b1dfad02d75b7f08161e7c45d44aa"
    sha256                               arm64_sonoma:  "cfd413411e94a5e4e6bca0731216b93d346b1dfad02d75b7f08161e7c45d44aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c147e00c8990fc0cecfd815ecb0e18c8ba1f7025d7965c6e7b7db666a1a72f"
    sha256                               arm64_linux:   "5e934a69103fa20a341921d0349381cded42bc5fb5c9c2189dcf445eea6055fc"
    sha256                               x86_64_linux:  "8eaa2fd691029a62e99e6181352f718c0b4f0b7a5a65c8b0b1f53a5f835b2820"
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