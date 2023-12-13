class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.5.tar.gz", using: :homebrew_curl
  sha256 "467373705604cb9cbf9c8363b0cec93aeb66b8de02742d96304f91181f5fbb5e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c40dcbd8ca2f4f971c978530cf8c0837afcd86c3969ba7681bd11b3a5fa962"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6399cc552fc3c6fadae5b67044a4d5f91928fcfc9548188d18ddf5faea00b099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b111ca832dc2d7b45461c830b2e6fc4c0314fa810556d2b18eca9e04499fb724"
    sha256 cellar: :any_skip_relocation, sonoma:         "be7b1bb03e14d3c6afac878e64f042013128ffa4ee836aaf11702c7003841502"
    sha256 cellar: :any_skip_relocation, ventura:        "f56f717a42abe111456f5f6e8456ed031c7ba810ca935fc1c9277ce6d770f8f9"
    sha256 cellar: :any_skip_relocation, monterey:       "b514d29c1f7b5f2e8bcdd8bb75463fac1c435f8e066791afd99412d1dc138264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dcc14f6b3189213e747b301d1b844421faf69750d77e97166cb9c1fc85c8e39"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
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