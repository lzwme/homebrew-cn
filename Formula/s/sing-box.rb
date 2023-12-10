class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.4.tar.gz", using: :homebrew_curl
  sha256 "483c7188f054dffc37211a4c6d50edc7473f9cbbe57c5687bb3551aba3919e52"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65dcbcfa0bca1be4815098e268dee517772b155eb072b24d2c3f1b803d99c55c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba2842ea9b30b68f495b2c100bc50130d41198983174082ba2dff3c4f339c5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c18535197fffa08eceef494ed5aa396c5143f22df4c519253b223d2be1821df3"
    sha256 cellar: :any_skip_relocation, sonoma:         "46fe5582eda25de9aca8ab977e5af2d13394a56a69db9b3367925aaafc2fbbaf"
    sha256 cellar: :any_skip_relocation, ventura:        "178a99b78e1bfc5dda8c3c360a0d73ba537273669f3c6b90a4d7c5f87b31611f"
    sha256 cellar: :any_skip_relocation, monterey:       "d31aeedbc02f163e30c6bc46f436f669f6886532d8a8014b3043d63e5d953d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6466b3286e3d3708d503a8535bb6b2529028ed45ee2c2fa7fceecd3605230fc"
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