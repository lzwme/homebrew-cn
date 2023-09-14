class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.3.tar.gz", using: :homebrew_curl
  sha256 "baf7c87f2e5005bf268975b1a2511f30927210b1607f20451fec2de0044edfa8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8469af36ae7ab197c87edd0c71bab136d1771136bf61da90cf40f62f1c6e4986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609269640ac0d912e7877999489ec343d3c1721cf501e1fce955ba3d9cd2e829"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59e72c34eb709ab6c8d6f6cb0be4c7751f808095dcda75b8f72430e2a61d27db"
    sha256 cellar: :any_skip_relocation, ventura:        "cee5fa0ed4a6d46b101193235c17c3b4465e08d9bedf96df260faba64e49b4cb"
    sha256 cellar: :any_skip_relocation, monterey:       "8d6ef0e3266ec3a7980fe34444dc2916442be8eeb208e5e6eb957ecea7348826"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd34543e1648d838f00d57825be62ab1313dee68b5878c09f9c10ce58063243f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a263d2f4a9ff5aa161a003d1333512eae567d89c19ba98616fd9b1df2f4cbe9"
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