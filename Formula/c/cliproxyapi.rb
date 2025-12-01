class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.30.tar.gz"
  sha256 "5537ebca32c365255fecbb97f183901161fec4532af71c00b765adc887023199"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "384fe81d60ec1ee6d4b868637318d3fc53338b2f7f26851a88d8048e84de2147"
    sha256                               arm64_sequoia: "384fe81d60ec1ee6d4b868637318d3fc53338b2f7f26851a88d8048e84de2147"
    sha256                               arm64_sonoma:  "384fe81d60ec1ee6d4b868637318d3fc53338b2f7f26851a88d8048e84de2147"
    sha256 cellar: :any_skip_relocation, sonoma:        "cffae8d016e43a3d8e57942d115656d9a0686ada018fea9dd7e7f5ebd62a7da3"
    sha256                               arm64_linux:   "b2d3c5aa4e0b9e907e6a0b48838a4b0d60047b2eb4356ba839e9044baaafc3cb"
    sha256                               x86_64_linux:  "ed9c311bddec80b8ffdb522d069f0d9bcf42c737ff7cd4ea0326a257530c04f4"
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