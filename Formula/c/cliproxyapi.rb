class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.52.tar.gz"
  sha256 "de6bead8c8092e904aa1a373aa4573419e146987edd24f4c7e946a8a17663abc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4a2296060cbb3b495a28ec3b015e8201293d1771889611dc394958d07e263b3c"
    sha256                               arm64_sequoia: "4a2296060cbb3b495a28ec3b015e8201293d1771889611dc394958d07e263b3c"
    sha256                               arm64_sonoma:  "4a2296060cbb3b495a28ec3b015e8201293d1771889611dc394958d07e263b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5a98a75077ecb19de598d7ee1769ec0b4d274b94883cc3701987356013b93d"
    sha256                               arm64_linux:   "266abb31ecd299615452a0ca3465d1e8ae105ae30746c4fbcbca58f89737f7e1"
    sha256                               x86_64_linux:  "68f0190d5a816834725177bdf87f2efd40d2cd21f9554048ac0143e645fd654b"
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