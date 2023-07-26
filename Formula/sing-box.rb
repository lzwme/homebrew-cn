class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.3.4.tar.gz", using: :homebrew_curl
  sha256 "5fbf7a2f743e98291769ee4aacf3bf204f98c134701fcaa3bbae4bb7eeae8fc7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35bda6ae8706dc6a11f318d8cbd86e2d1b28d3e421d373107729b25c104904c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bda6ae8706dc6a11f318d8cbd86e2d1b28d3e421d373107729b25c104904c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35bda6ae8706dc6a11f318d8cbd86e2d1b28d3e421d373107729b25c104904c4"
    sha256 cellar: :any_skip_relocation, ventura:        "18307a09a5b267dfb8ad39d41166cf0c71e7386b6e5533ed7708d16ee76ef373"
    sha256 cellar: :any_skip_relocation, monterey:       "18307a09a5b267dfb8ad39d41166cf0c71e7386b6e5533ed7708d16ee76ef373"
    sha256 cellar: :any_skip_relocation, big_sur:        "18307a09a5b267dfb8ad39d41166cf0c71e7386b6e5533ed7708d16ee76ef373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897531e886743c56446b089ef354c04225bec53348b5ccde3c303d704a32100b"
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