class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.4.tar.gz"
  sha256 "4e429df25b63cd7c0542ae187b1eae8bc4ddf2d502c32d14b5bf5e1ab396af19"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "369f53dbb953d014e57edd6f9f4b45a4a6382701d9c09306c4d00dc0c0964559"
    sha256                               arm64_sequoia: "369f53dbb953d014e57edd6f9f4b45a4a6382701d9c09306c4d00dc0c0964559"
    sha256                               arm64_sonoma:  "369f53dbb953d014e57edd6f9f4b45a4a6382701d9c09306c4d00dc0c0964559"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f67250c4f064b2c31a1909a03e2b195a19ae81b023cabe2c7485b8c3585a9f"
    sha256                               arm64_linux:   "84ebc2e703a6afd8c3f902f8c28b25106d0b600f315c99ef8be9a2f6491c1b4b"
    sha256                               x86_64_linux:  "6b23ff8edfd9bf6aa5a5c4ec146cac258c404d09cb365549b3b68ea0c5851ef2"
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