class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.20.tar.gz"
  sha256 "b4b231909fa32fc6f32d0a536b787481ca63fc0311f5704fed230d71da03d0ef"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "436d7ce01e370883566dec6f9ac8474ac7460845b7f308d042104cc8fd1cad00"
    sha256                               arm64_sequoia: "436d7ce01e370883566dec6f9ac8474ac7460845b7f308d042104cc8fd1cad00"
    sha256                               arm64_sonoma:  "436d7ce01e370883566dec6f9ac8474ac7460845b7f308d042104cc8fd1cad00"
    sha256 cellar: :any_skip_relocation, sonoma:        "efae1ba48c85b4a61d9248d2ea3c5ca15e141656d875d765aefa813b0817c31e"
    sha256                               arm64_linux:   "4d6d2965ee62ab24a3b7d7ffa346ec4a590be3a5bd2ddfbcfef60d56320a092b"
    sha256                               x86_64_linux:  "81f2e2c1fd7162c94260c25dab0a1a367240ddcdbcaf31bbaea0860728b28eda"
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