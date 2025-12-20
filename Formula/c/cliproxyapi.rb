class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.34.tar.gz"
  sha256 "061380d7aef6936211da6736c76f022a941723b34e335145b9686bc4e708d191"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b8cf3aaa3f1d9db1992c6a00528895be4cf56ad89fb132f97bf6457b25c36e50"
    sha256                               arm64_sequoia: "b8cf3aaa3f1d9db1992c6a00528895be4cf56ad89fb132f97bf6457b25c36e50"
    sha256                               arm64_sonoma:  "b8cf3aaa3f1d9db1992c6a00528895be4cf56ad89fb132f97bf6457b25c36e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed085321897a483c73854ef495bc6216e5de63834e51977d87c94d2d48b28892"
    sha256                               arm64_linux:   "46992e69f5723b74c54b54a612a3360dee6ef2fa3819a8e09fede8dea1b44f34"
    sha256                               x86_64_linux:  "3785fb895807a87a3a4d4ac162c30a51dc6aba2a79c46dfb1d31ad063171532e"
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