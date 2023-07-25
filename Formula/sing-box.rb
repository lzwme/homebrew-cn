class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.3.3.tar.gz", using: :homebrew_curl
  sha256 "ad168dec674c32b0be5a78ffd35ac82681e6b04d50617b1e8701889b567d516f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0abce21df40e8c5753eb13f522ce77821cf501b32a56cded37550bd4bd5260a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0abce21df40e8c5753eb13f522ce77821cf501b32a56cded37550bd4bd5260a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0abce21df40e8c5753eb13f522ce77821cf501b32a56cded37550bd4bd5260a"
    sha256 cellar: :any_skip_relocation, ventura:        "b459474734ede27838793656d129bbf4c084abbb509479e04a7464bb37f3bcdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b459474734ede27838793656d129bbf4c084abbb509479e04a7464bb37f3bcdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b459474734ede27838793656d129bbf4c084abbb509479e04a7464bb37f3bcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a186c0fa8d44a570993c9603e6098c82c63af61fcf121eec21a0afbc61a615"
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