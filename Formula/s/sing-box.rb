class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "f19761d09f88e2d33aadfdb3c4ff471654f34b28561826e4786b9859654ca887"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24a7741acab96325c27b56f01b75f4bde871ddbcff23a28d7c1468fcdf023f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb5728d097ff871b75356d806f261ffb6c4807623a7b204567bc9f19c060d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "528ad617a589dcefeab16610d702a77e16d423be5c597e3e8ca113fab4bf2106"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8630fd3e20489025b21dc32a2058c2686817c4eadba1f004393fbb7c323ade3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9ae4079d20cbaae5c37a4aea613278c993b0bed7ba6b8013ab2dfe21273f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695f870969368d4ede4ce862a5ec948e7949df5d3c7fb31e49ff86b7ca6bb094"
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