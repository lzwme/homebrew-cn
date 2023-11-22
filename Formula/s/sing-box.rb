class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.6.tar.gz", using: :homebrew_curl
  sha256 "88c8825f6e8af2e46a16e8a85ceb5e1c7c0795b59cad93c8327288ec7b8249e0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40148e5905b8005315042f1bdc26d1f4bca4931682ba83455892d5055832f812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee310cfc21c87c68511f9ccd580bf8fe6d525eb5ab37b84379eaba080f634f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f59eebfb1b9a00e8a61918d5620fd3f1a665c732a06799e978e0c80befea522e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6c159dedd670820d4a9aca691efef5c6ee8f4900747aabe89ca25afd42381af"
    sha256 cellar: :any_skip_relocation, ventura:        "b13818935a5e4cab7781865949246b3605dc5ecd9099fccac6cd14226fdbd870"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd7d6c85522e36e31a452898afb2b4f6735347d26ca43a996492adf9f083268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482f7409ec9aa23b584f693d896ff4da853a2f2f7e231a08b3f1457abcafe351"
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