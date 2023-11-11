class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.3.tar.gz", using: :homebrew_curl
  sha256 "3bebd23dd5d4734a90fb8821b3c2c0be0fd34800d10e6a4e0db95e06578cca1c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0f85904bc037fd27a36347607efa706b59d94e994c4b3c8767c19c114a0c39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9c2848866312a1e75dd4c0e8f26bd5eb9cb0eceb646bde910cea250045579f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f8b63e199567182b7afcb8d844927156a57c7a5b75117927cd92995b4a9b3a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e451c1f378a9b8f67d01d215c9776661b17e77cc923ee8056fd8719f662668fd"
    sha256 cellar: :any_skip_relocation, ventura:        "9e434591beea1efb684dc7e59bc7ce8e94217f7d51cd4a62cc19198c6ccded0b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1cf6d8efad708c7a69c374a27e527e5bec191c463efb97e56a9cf551ecaceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48afd60f328175bcf4207fcd09aafd04149218a49908dbe09d93733802a33fb6"
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