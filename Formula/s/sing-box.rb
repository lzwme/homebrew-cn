class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.1.tar.gz", using: :homebrew_curl
  sha256 "0b19797d806c5739837e53d9c1207ae7bf674488cabd3f125ecf3e7f9cedeaa7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce1a4aa6a38de98a8f8026027c48eb79547e64a5fce6ebd8812d03a2589684be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d996e33a983ac28a1fd631d03b595ee6807982d4560de260588c452cda3d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3dcbdce957f0d8f8fb7bf6be1deda7e876e2ff74e72b989d6d20148844bf2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "19581f76b3ce29ff67cbc8920deb5fe076624f8155b62adad15eaa3fd114cad7"
    sha256 cellar: :any_skip_relocation, ventura:        "af955f2af81948a3e8bf31413baa543d8c9ccd39ae6105eff4e99cd43cb5f5d8"
    sha256 cellar: :any_skip_relocation, monterey:       "bf32c53128d19b09f67bc41820950a625712bc02f2c8927621d4d75b4c377bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dbea0fdbf7dbaa7715582662bdbc906f307e1f90a11530a8fe1d8c4f954607a"
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