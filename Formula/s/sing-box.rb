class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.0.tar.gz", using: :homebrew_curl
  sha256 "ab6698545442e9197339f459553e241ff91396ba39a8e5d14e0a792e78d290a0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c39cd4ca9c46134655c7f7f55c54f711476dbb110188b3ce9d3f41a81f25de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed9e519d97dddac952bbfa61d90b0d7c5c972a2686d5b65f8f7294135874005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31ec9e2806cb6293136929dc6ff84a9734c67a5619c7863a160bfa1aa9623a9"
    sha256 cellar: :any_skip_relocation, ventura:        "556d3b350c68279c911caf1e124b95b6d4c1841438ab2f9fb306ec096832e528"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5a0a3fcd61453182b1c25ae1afda98b0084878583a1a4ca5c83b6b8a992f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "58ba18e4bfc26df4a38f4aff1ba0b042b7b6f59be8feecdfbd4a593926da8c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e657c336ea097e65cbeaa5788c59e0a2b6114a2ddf7c0d02762fdd9aee63031c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    server = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    system "#{bin}/sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", "config.json" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end