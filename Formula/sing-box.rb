class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.1.7.tar.gz", using: :homebrew_curl
  sha256 "d0c75af7a5b649b5f10af99e845134741dd4ea4147d804c9d0d2a3a552843356"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9de92521d5ac0c51e23085a99b6f8fc6187a129d6caaac2c08bcb9631e02fd1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de92521d5ac0c51e23085a99b6f8fc6187a129d6caaac2c08bcb9631e02fd1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9de92521d5ac0c51e23085a99b6f8fc6187a129d6caaac2c08bcb9631e02fd1e"
    sha256 cellar: :any_skip_relocation, ventura:        "0b6a2d272ef2ea53ac980668fd984d221bf09f3322755ddc19d0b06ebbce553c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b6a2d272ef2ea53ac980668fd984d221bf09f3322755ddc19d0b06ebbce553c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b6a2d272ef2ea53ac980668fd984d221bf09f3322755ddc19d0b06ebbce553c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90183fc33ca5630a838b54735dac35a2ddb618392e51093e520906a6c4941af"
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