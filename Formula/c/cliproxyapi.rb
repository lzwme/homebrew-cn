class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.60.tar.gz"
  sha256 "b42d26f15f54c4f56699ee2ee498785feee8896c3ede06da4b1af0cf1ca08d75"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "ba4d838876e7f37b8baad55368539342b61a986fee07498ba6cd797a426a8f14"
    sha256 arm64_sequoia: "68482f7baafda6d8cccf074d0f397212a11d6e0da59ceadb995ee3319bfcb3b4"
    sha256 arm64_sonoma:  "222134233a1cc277e5678abb63b57f9605aa3a4de4aaf440d1fa0ea0535b7099"
    sha256 sonoma:        "84d566ededef0beb0c306aa1f85116fc046109979dda82f3a2a4c02ba891300e"
    sha256 arm64_linux:   "31a4a0a767d596881a73dd31c4ef0cc8a8212677dff90ede5917c1cb139eb095"
    sha256 x86_64_linux:  "5f37097ddb8ac9571c8248abd2057f3bb7c595bb02a4473464e72ff47211d39b"
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