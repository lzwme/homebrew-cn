class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "9a14ffa04fee1a1091ca1995a45f3e3feee460bddff0a72da2febc05a05b2660"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018bdbc7421713c542c89005d0f8209181592d90e70b7b24836576d50c3d7860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2ed996e5270b9c1b24abb31e86f5ab83d85dcc4f1426d8515b18b58cd876e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "293db341d606400cd947b4e5f9566ad3cbf6ace058a252a7a10bb64b17f022b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4eb140f729fd97465d11f1090126dbb88e5cf71c498aec0b3fb2d84f02f57b2"
    sha256 cellar: :any_skip_relocation, ventura:       "a6aeba2b80b2eec180641331cc50bd0c1f2756770ee8cd4690b0aab013091f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed6f42b101f77c8cbfe4d80bd7ee97a423f49956ec534f57bf127f0df1ef248"
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