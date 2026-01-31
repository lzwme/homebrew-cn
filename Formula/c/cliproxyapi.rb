class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.35.tar.gz"
  sha256 "a9b98c2637f5ee30b691020ef64c15495c8de8a2a5e0275c11d0d91ed26e1fa9"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "8af7ca5eb513f54e3583c2aa5381530df4941d0f7c75647e6f446478dc8e3290"
    sha256                               arm64_sequoia: "8af7ca5eb513f54e3583c2aa5381530df4941d0f7c75647e6f446478dc8e3290"
    sha256                               arm64_sonoma:  "8af7ca5eb513f54e3583c2aa5381530df4941d0f7c75647e6f446478dc8e3290"
    sha256 cellar: :any_skip_relocation, sonoma:        "91cae42139827b5a64fbb1917e8fcb9ca498bd323125c30a3ee2559b5bb4cf1c"
    sha256                               arm64_linux:   "497063f41e32e6d6f0ea944882a8d41f4eccde22a03ebc30799bfaa19e1cef97"
    sha256                               x86_64_linux:  "02730db28f9992efbaafe473e6e4ae97f0c90c9ed11b0eef115dca856830955b"
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