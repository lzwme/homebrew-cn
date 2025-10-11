class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "7db58b28e93d1f7dde0565fd2a2d82979d18a82df48623a0a99455278cd5c372"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b155a5a20feea93aefd783a6690b18678e1330e3e14a7ceda027ce8a4834e82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398ab2e22c5a80c6015c6205c021e0cf96a982a67d3fd154a52c5bc9d2f1db3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ffa899f35a0ffe6f1529187f4e48264637dfa576955ae1b5aa80ed87295062"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9343a48e7348f203bac0aeaccaa8c489ad8e1c37bbc3b1d9a1985d0debe27a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "594c471639c172ae43cdef3dc8cd8c1766596fdf99ed0458aeb2261a065b385e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58fb9c2ac64d408c1d614978161f35cbc4a84a507aebcd230476b3e577ae67bc"
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