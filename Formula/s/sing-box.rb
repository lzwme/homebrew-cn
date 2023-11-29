class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.7.tar.gz", using: :homebrew_curl
  sha256 "f4da7132dd21d0ed467bc1e146ca0edce98b205ba8d9e41514d3210c1c63e06f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09a1c7a08a5927694efba11c00e761eb7b1534d459f803844e7e32ed935a1795"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5907d03c6d1873ec9d088481e97e3bbe221334e9f274661994eb9e7feb2c5f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05182fc7242669ec142bc9c4111b224e42e9d6a9e62ebf1556265123544facd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f0444cfc30009bfb58ddd832bc22405ff96ab7bc8a10ba6dc3272d7debf9cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "8116041d8597a1fde5787570112b888e56fe57b526fafad1c46d20b8fb154a77"
    sha256 cellar: :any_skip_relocation, monterey:       "c6c36d0961415e9bfafdd7a0ef437463932cd05b0f4d02d02c9db2c5384f4fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "742dd4ab7da134b831d40272ac9a746c592fb16017285228d65fdc2e0f9c6fa7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
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