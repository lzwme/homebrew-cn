class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.5.tar.gz", using: :homebrew_curl
  sha256 "a9a8f0ed22c566bfe7cabcbe947384639e7e0eb6f5f287c2b8c7c9d27820e289"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88a98eca8ba33a87817207f7097b1da5106d056ffcad8cd19d0f8421db22cd64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4980dcc00ff74ac8c8f09b5d9fd2a2a6850ee6e48b46f9a71c2a513de0dd599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db1deff3e5b7ddcc7faa8e478347648e3b1cfcd90428c7209b21271d97a4463"
    sha256 cellar: :any_skip_relocation, sonoma:         "73da8c16cdf6927b8627eab5ac15f4ad4b07a3c3efea928707075b0ea562fd2c"
    sha256 cellar: :any_skip_relocation, ventura:        "916266a8888c925d4d21838f35c364d17ce5543eacf1a4d8020e5e4953571ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "64a69cb94876af6b736edbc36ae06d2210ddf63a18a3cf8d31f0898698df68d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b069b30d11f8cfb5d2abddcc4aee86d2b6d6e30be1fd84b0317d673fbaf49a"
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