class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.30.tar.gz"
  sha256 "19b91ec9040c8d96a3ae7c4cbd822757c4761c51017a6803afa0d92db813391d"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "266e9237d3439ba3b2f3d8a090c4f2eef1d755d0fcbd2b2382a6eab35e302e9d"
    sha256 arm64_sequoia: "027e404660304ccc35b3d268952bb5e51a6d42b3153428d806c64126cc06adad"
    sha256 arm64_sonoma:  "ae462898c856159217777a7bd96300428770da7c551c03716bbfbcbb230acaff"
    sha256 sonoma:        "bd10790321f31bc4df6eaa5992796d8d89a213ebe180c8a037a1b7415c5faab4"
    sha256 arm64_linux:   "ab56224884a9c2d00743ca639afd868a695e5e9f9afe210f2d36bcb5edf5273c"
    sha256 x86_64_linux:  "042be14b35c3496eb81d74fd5f8ec8d2a03fd8c5d08889e77b6b9a9aad7ffb85"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end