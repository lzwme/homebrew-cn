class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.2.tar.gz", using: :homebrew_curl
  sha256 "afed0fcfcf5ff92a8e0496af0813366cdd14279cfb08ab45a4d1309dd62191ae"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a85a87870083663e206edb2fde4ce4d2746f96e621f1b55399b0ca45404951dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24965a3d30c62715eb031e9c19bdfad01db8f0909fe5d521a11ec19bf2f550e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e32fcfcd18e644835b1c795801ef89e57cc9adde7ea24487daf44f71e538b8ef"
    sha256 cellar: :any_skip_relocation, ventura:        "c19ebb6d70d634948588bed77412e48979e965a8b67ee275b959f242abacbfb3"
    sha256 cellar: :any_skip_relocation, monterey:       "54e226178ec4d9fbb8483db299959214b27b474a43b94bb9451306d19fe1db7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "12020be19aebf27783659c19a6d49841fb9beed929c00d7118e8eb1a63939ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68246fb341328ca9cf2487070dc6c48b477138c2e26591bf625a3d990daca73c"
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