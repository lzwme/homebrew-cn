class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.2.tar.gz", using: :homebrew_curl
  sha256 "eaac366539cba4c736f3957e959f9a62b53f932e442fba584577218fa2e71b5f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0081a19f2e44721ffd7fd97ff31b90e2720fbfdb20054b1f334946866232301a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0081a19f2e44721ffd7fd97ff31b90e2720fbfdb20054b1f334946866232301a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0081a19f2e44721ffd7fd97ff31b90e2720fbfdb20054b1f334946866232301a"
    sha256 cellar: :any_skip_relocation, ventura:        "1045ff4cb76a0645dec97028d87449e40dcb83576f398d4f422e99153d09ab51"
    sha256 cellar: :any_skip_relocation, monterey:       "1045ff4cb76a0645dec97028d87449e40dcb83576f398d4f422e99153d09ab51"
    sha256 cellar: :any_skip_relocation, big_sur:        "1045ff4cb76a0645dec97028d87449e40dcb83576f398d4f422e99153d09ab51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd40f4c33953b363103e5685008f94a7b0801da999df0c6e6c247d845967fb1"
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