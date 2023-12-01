class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.0.tar.gz", using: :homebrew_curl
  sha256 "e9cc481aac006f4082e6a690f766a65ee40532a19781cdbcff9f2b05a61e3118"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97ce4fa8a305ee20eb905be84956fa4197c07f3b8b893014072ab440ec0ad92f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e6ac36e29f03b7be0797a517911b72c62376b9726d893c2518deea242a7d10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72cc081256c0e9dfd6f87367b93d2b2e2ebf2a2c13ee88d80779b17eb091fe49"
    sha256 cellar: :any_skip_relocation, sonoma:         "40f48f4f91bdb495d0d390db9af7673dac6ecd4182a3a1950e7b4dc3fada3259"
    sha256 cellar: :any_skip_relocation, ventura:        "5239eb23fd7d6209ee7b05679c77ffb58b8bd051bf4481b2de792dbf98f140cc"
    sha256 cellar: :any_skip_relocation, monterey:       "31720f21ae9c395374a7f91cabcfef160cba6cd5ce2ededad341996ef65cccf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4beecc1454e4a76cf63797504c2f8f0464011ea2972fbbf6750e809cf31097e9"
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