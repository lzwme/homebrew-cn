class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.38.tar.gz"
  sha256 "d338c21cd10f7dc9db40296e1acaf740fd1f1a18c5fd9a1268918cf37ac1d000"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a9e6b0d84d90caa1cc07a7852d33b7bf6e80df7bb84a9604562f0bdf6b66290d"
    sha256                               arm64_sequoia: "a9e6b0d84d90caa1cc07a7852d33b7bf6e80df7bb84a9604562f0bdf6b66290d"
    sha256                               arm64_sonoma:  "a9e6b0d84d90caa1cc07a7852d33b7bf6e80df7bb84a9604562f0bdf6b66290d"
    sha256 cellar: :any_skip_relocation, sonoma:        "18a044650a50625e3e6e37bb1ce5844730853936633abc17269305134a83a4f9"
    sha256                               arm64_linux:   "d89e744b4de1efed23550a17c73d5ba6ff8001b90dbdb21f0e8e66af6acb2b10"
    sha256                               x86_64_linux:  "dd30d8e71495ae44352b7f581c88220bd2682c858c9e321ecaf9da29517c653f"
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