class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.1.tar.gz", using: :homebrew_curl
  sha256 "73a230d04bd2b20198b8fed5df674fe6507719044edffcb6c8859ed63cb02faa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7aa84d33d63119963287f2fb0e9a24733394685b27c06b09fa6356222fd28266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4069dca56a8b559ef784597abed00ca418076a6e0fde9d3dd3ca8170798fd83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522208a590858c3122c9b3c1dd5723551b39322e4711faad44ace26a18d0fb6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe4463e2e6159528a8111777eec9bcc013ef9f1df2b257810e96ef873ec9bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "12b2ee056c1ca5edf3d0d13c0e7db2357d661d18ef9f070424f61e68008c5f6f"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8b012fe73fe1cc19a74a6182af27361ccb51a84f6377bfe33d1d13b29bdb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3740c786bc81623d3be2fc176a3e7e04b4fb271fd17335fd7d7d73af9110e4d"
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