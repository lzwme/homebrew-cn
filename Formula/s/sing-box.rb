class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.0.tar.gz", using: :homebrew_curl
  sha256 "4e2447907a5891aaa5e8c8aa272bc530f7098449ef76e624a2e7c917d41c2a78"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8d79f400d995c9f5b44adee5efec2b54e117c0a114062e8f5486deb3bc57f8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024d4f2cd721aa28a8acca646b68522947f75d133f9b30fe24e357d4a4af9ec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69016e33bc06d8a0a7ada259b3db9f7c9d3be1ca86aa6895c0074afc1566edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce497232a15cddb2a13228e6c72cad09448a12a1fa78ead0642459a3b2ba593d"
    sha256 cellar: :any_skip_relocation, ventura:        "404c67db90aef8547c48e083bac0fa3d8de0c36bb520dbb4447d3f7ce9e8c6ab"
    sha256 cellar: :any_skip_relocation, monterey:       "67de96f43e2b8ad8cad51ff9bcdbb7f01a37f9c55cdb99b288209a0c4f654e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e55f2bae68012ba47900c9446ec56370a899585adfa29f596df38597c36f25"
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