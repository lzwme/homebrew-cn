class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "95d902c008ed0b414ab29408dc565310fffe435a15753e02d10ca5c8e6837ce5"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53d47dbf58a075806f776ac02d3cf3eeec49294cdf1f468d0da6271343df63e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05e89afd93128a0db930d8a6b1df4e4bf83a37d8bceec86a6622fa0c1fadc3d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88999c2b9a876a198e1cbd5e658e21119f6c4fd3361c7a940e9bb0df9af39fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "23a55d8c76210186a9c0dd477593afa47649ab62969337126200b71a04b27d71"
    sha256 cellar: :any_skip_relocation, ventura:       "cbfed59f8efff92aa0b5784b33a21158bf10f77331c0e15e7555e382ef895538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4566a7086b6bfc559465c7315aef837f637712e0a42c01abfae00cd885ef4847"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = %w[
      with_acme
      with_clash_api
      with_dhcp
      with_gvisor
      with_quic
      with_tailscale
      with_utls
      with_wireguard
    ]
    system "go", "build", *std_go_args(ldflags:, tags: tags.join(",")), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
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
    JSON
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
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
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

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