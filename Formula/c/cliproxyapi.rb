class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.15.tar.gz"
  sha256 "8f879c9a153ad02ff584fe1b9d5775d40480b8287b5d63dd90e036fd03e2cd36"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "92ec492894bbab78dd07dee5f9b326a3b8b473d11f46623e68265bdae72b66ae"
    sha256                               arm64_sequoia: "92ec492894bbab78dd07dee5f9b326a3b8b473d11f46623e68265bdae72b66ae"
    sha256                               arm64_sonoma:  "92ec492894bbab78dd07dee5f9b326a3b8b473d11f46623e68265bdae72b66ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c23f6167066033c835b4e5678699b76588846ab8080d0832f4a3d634452463"
    sha256                               arm64_linux:   "f1843510d8860426a1a8205ff15065cd526211765df2710271414d4a620cd850"
    sha256                               x86_64_linux:  "55b99f730e3ad2cfeeb89e63c1cebfb560ac669e159dbdd81e63bc185401b98c"
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