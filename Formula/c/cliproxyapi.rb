class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.21.tar.gz"
  sha256 "18427eb30b740750e69b8afad3d720ddd48016b27b656ba0702a7cad99d5e9d1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "09d4027be9777159082bb8010564a709f1417cc3a7feae00c40f7f1c1c55dd90"
    sha256                               arm64_sequoia: "09d4027be9777159082bb8010564a709f1417cc3a7feae00c40f7f1c1c55dd90"
    sha256                               arm64_sonoma:  "09d4027be9777159082bb8010564a709f1417cc3a7feae00c40f7f1c1c55dd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a648b9b437e8b59dc81fdd3104c8e9ecdf85a5bbd154f893768ca4f199b0dfe"
    sha256                               arm64_linux:   "c3f518bcded7a4a48dff2e2a3eae9ecf6b8d8fbfda061a0c4ccc91b3683d5396"
    sha256                               x86_64_linux:  "6d397bed0110810392143b9aa6388a4c7734f3567ee4e1e9dc80546bd723c9a7"
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