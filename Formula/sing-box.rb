class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.3.5.tar.gz", using: :homebrew_curl
  sha256 "7c4d5d65d4a1a37cec1df069262b5aba508a67bcc9f7261325113555e3c458d2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c6265bad3e317ec6e7d077cdbe940a430682ec5e740c0135d39fce793ae6680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6265bad3e317ec6e7d077cdbe940a430682ec5e740c0135d39fce793ae6680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6265bad3e317ec6e7d077cdbe940a430682ec5e740c0135d39fce793ae6680"
    sha256 cellar: :any_skip_relocation, ventura:        "b5eae17d350f65dae0a3def47c8ed61906be6c295a19cec3666a7eda23f8c474"
    sha256 cellar: :any_skip_relocation, monterey:       "b5eae17d350f65dae0a3def47c8ed61906be6c295a19cec3666a7eda23f8c474"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5eae17d350f65dae0a3def47c8ed61906be6c295a19cec3666a7eda23f8c474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d7b8dc6eb340df75460c68c36dde1f7299605286369faeef447c5d6e5ee849e"
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