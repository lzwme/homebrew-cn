class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.6.tar.gz", using: :homebrew_curl
  sha256 "3521e5ea51ff5a4a30cb8b0ae5aabece603101636f0e1ccbcac1bbf376c7085d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d879887dd4dea9979a902c823234ba1b591d011708366b9d1f0b6814801adebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c9802180a628487d3c3a7c8c053c0e0f82ca74d069a014fd7211fbdb93a789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80d3b5e058d7d386b18cd6efc3f73d0e506530c98db3d41e41400518c2a6370"
    sha256 cellar: :any_skip_relocation, sonoma:         "9caeb16f4f33c62af57c542f16d793c6177bb4476d5c16874b24f2d473dc58fd"
    sha256 cellar: :any_skip_relocation, ventura:        "ed10937ff0460b1d805e3da0d4bdd36082edcb5b48af9e3268d920d40862cc26"
    sha256 cellar: :any_skip_relocation, monterey:       "e421b65334608f63daeea3b16e966b29444a810c943e50b352511a2e372ede88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bb26fcedc9e33a6c9c0fe1c58b82343426de08780ad3d68c97eec16d6c4133"
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