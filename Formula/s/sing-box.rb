class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.4.tar.gz", using: :homebrew_curl
  sha256 "3b1008d8a4d0cb0c41841531b1845b9b859a5d8f73af2c9a137fec4c7ad1f18f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a80ed83eeab949b29cbdf51694abeb47ccfdc26a55174c932c5adf8ed1de202c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a8f5d0a608480c38cd222a5917f606f585ee63e88bf5fbc0cbcf5ee760d4973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d54927b0d211cdca69a4241a5f49c8644f659f8d970dcead160a690ea2ffef"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ba4ab29c7785ff7faa106e3f4579547b7e64aef8718c785754dff054581e3c3"
    sha256 cellar: :any_skip_relocation, ventura:        "325a23bf21b8b2bb12c721f3ace608a59e6d1774565963a2dcaa583294c5dcfa"
    sha256 cellar: :any_skip_relocation, monterey:       "2ddcde67cb686712cb15f7e378a224595215644e8da2170285ec28051fc4ba69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe88186d8c42bdb91ef57561e4530060886df6aea13fdd07418eb2910882647"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json"]
    run_type :immediate
    keep_alive true
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