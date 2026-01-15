class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.105.tar.gz"
  sha256 "e8b9dd2f46d2ff861dfba9f53f43adc414a40d6bb58980de1bd8de03b0c931b7"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "5ae118fb5108c35cfd51aeb46af106db32a9664c2758e6c0878e55133fd22db4"
    sha256                               arm64_sequoia: "5ae118fb5108c35cfd51aeb46af106db32a9664c2758e6c0878e55133fd22db4"
    sha256                               arm64_sonoma:  "5ae118fb5108c35cfd51aeb46af106db32a9664c2758e6c0878e55133fd22db4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9e0075f98ab51d218c96a4516838eccc0bc34b87cddefb5126faa284493bab"
    sha256                               arm64_linux:   "b5948222c71afc1ff57f4bbff6aabe7eff5202d2b71ada82ee24c03e961e33c2"
    sha256                               x86_64_linux:  "867c16c4431bd2a711a7a7b439247516f48f04a04355e7b3291d8bdb50fe62ed"
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