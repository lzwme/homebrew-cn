class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.0.tar.gz", using: :homebrew_curl
  sha256 "3272c9ac447d009749429f38d76e9879609c0c321442c3235ba806d995c0838a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c63bb381a74579ef215f3a9a9b5adc23b17cdc26a5d8be6ec3df8842ea004d09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d50b1f33d37248c064f888451d3355fccf72fe66a89f5bf6e12c06266b1dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e554167b544aebca5cdad91101aefbf8c01b49ee970835e35e48fe80d21bab"
    sha256 cellar: :any_skip_relocation, sonoma:         "25a5dfe694fd23297c558c726d8c8659c710ea35f72e6e3c85cc03439e693a42"
    sha256 cellar: :any_skip_relocation, ventura:        "b14b30ac9ec961ceef05113b0828088cb61b07b573dc22a8fa753b6059c20d43"
    sha256 cellar: :any_skip_relocation, monterey:       "50cbc32f5ad344c7f694c1a0d243279d01ed2ada57f61c1768450473eebca535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634f9364c7ef92f3fae6ecbbe25f445dfc8f1268e797e167ec56c8e4bad75322"
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