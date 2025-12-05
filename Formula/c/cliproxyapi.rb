class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.41.tar.gz"
  sha256 "5201fb424eb533f240b210e55ef86e6d1476eaff277a08fc081c8e6d0e57128c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "903b556fc8d9a190c748f0a3e0236c434d94145ccd98ea0628b846f8f9a61aff"
    sha256                               arm64_sequoia: "903b556fc8d9a190c748f0a3e0236c434d94145ccd98ea0628b846f8f9a61aff"
    sha256                               arm64_sonoma:  "903b556fc8d9a190c748f0a3e0236c434d94145ccd98ea0628b846f8f9a61aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf05b2cf61814a50dae1d721eae5cd5d888ca82065b7b922886b6ad18324745"
    sha256                               arm64_linux:   "6a5645fe97cc62b82c18625584a8c7e673191f414d94103e425e2e7c231f4203"
    sha256                               x86_64_linux:  "53c47f829fbb3d294ecb5c7067b0787c1f5c44830431fac52120374a526961c8"
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