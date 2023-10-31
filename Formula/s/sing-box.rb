class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.5.tar.gz", using: :homebrew_curl
  sha256 "ddb599acc2c7ce99bec22bbae96f054b4f7193916b61c641743a3a52b15766f4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58d8dd41ad0d5955849cdd3f80a4dc010ebf247e9a566aacce749c1df7158e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0c6678a07407e96e3a9f4db16948fcb74bdc6aecbdcb7ed30794bee91a526ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06b6daab45ee932be469cd01e2d0a172b4c649816c292ee88a0879454fcc15b"
    sha256 cellar: :any_skip_relocation, sonoma:         "076bb1e86da33c6390d31d2e35096c84352336fcc047b68285d236815c09abd6"
    sha256 cellar: :any_skip_relocation, ventura:        "304c5d6f8c3024a84bc94a33e5f6bc0e9652d44ccfdcb80720af3c6d2a228d02"
    sha256 cellar: :any_skip_relocation, monterey:       "267526e18753419f9aad44ccf541c8288681ddeefe1c856f2a5f52bcdd5ebb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55965e80e83825448c93be32f776421f646bb3faa4349c0d9b9142ae60f12f46"
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