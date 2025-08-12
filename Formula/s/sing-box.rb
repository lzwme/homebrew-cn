class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8c7de6f996c9d3ad363d60b52828dc649a579ae8a5f0b596fc8ff7ea7622908d"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5215b7009aeca772d1111729c5f84c0dfa6751cef46fb774c2fa5dec3c5e65da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07733668d189e60b9e843a943dc8262b1169fddeef674e5b5ff9305aeb78dcce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "107340b4c31f4d01265f859bebe1f5ea4320d72b017b9f7bd5e16a3f2e44ece8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c42f1c9f0111ac0277c971165e9af2620f18830cda5df44ff61812aa984b5f"
    sha256 cellar: :any_skip_relocation, ventura:       "2f7119609aede78a01f8ab80672bd40afde052d60f43114e390690bf8f336e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa0bff9e081221b2247cee6ee6db993dfe2914f476bece09bfb4ec6fb1415c6"
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