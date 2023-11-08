class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.2.tar.gz", using: :homebrew_curl
  sha256 "bb4ca130f4deaabdb5addcc873a5976f14e2573077985492e88ae37ec9fbcc45"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47617f0618d7d2253f8b806db50dbf5de90338de309dda20e15f267752d256a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92c84217f179fa043298225dffa1132238fb21f6290c23b583fe364b93831556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ee91947d76a9714feac72eb02b269f62a37217173adbe1d6990feb4485141a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1720cdc60a71266ef212834706ad8ff8fc66af252f4d73a6ccf8989a458a5f58"
    sha256 cellar: :any_skip_relocation, ventura:        "5670190915799a053dbe282c45ffc0554b5f8d903ae16f647428939ca02a8f12"
    sha256 cellar: :any_skip_relocation, monterey:       "2f03d7562623bc8ce61122d40eeef705e39197a578abebfbd03437164a9cac61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6c1b1c85a832ce2d6d71ba59f764a74b94d64d4567cabed975a54c00ae0d79a"
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