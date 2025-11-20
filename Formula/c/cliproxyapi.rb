class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.57.tar.gz"
  sha256 "afe426e8261342e19a27edd7d1ad0940312d8b7b523966940c3838cdc571620a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e7ff5189ed5a948c8add825eda1c53c970ca566d161e33c05cec96560ed5a280"
    sha256                               arm64_sequoia: "e7ff5189ed5a948c8add825eda1c53c970ca566d161e33c05cec96560ed5a280"
    sha256                               arm64_sonoma:  "e7ff5189ed5a948c8add825eda1c53c970ca566d161e33c05cec96560ed5a280"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8973385f690f26a757dcc30ac672a8d49ddc105c8fe218263e7e8d0a2dfae63"
    sha256                               arm64_linux:   "a57a4536cc259997ff4c8ea8aef6ad9887a7f1e98bc30c3e9c14eb01fed5ec27"
    sha256                               x86_64_linux:  "83559ab975b73d429536e923b6393292635f5bd9179d66debea8c6840c053913"
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