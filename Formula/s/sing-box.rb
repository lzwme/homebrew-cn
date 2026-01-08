class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.15.tar.gz"
  sha256 "3068e558f0a075dc768b2b00ec8b33b5920c92fbbf65b7d336c098a0fa515b21"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d8aeccda391db63ea284f75b200260c2b97033c8f07698cb9f28df81a655f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7fbc5230cdc2715a2ca0121a8f71456142c813665528046b3f4004b1bfd9592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bd58265dce5f4f2a8edb2e883e6bc3668ed1ff6b71160d2aad2025f7f45f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7deb7da43c85bf5a75d29b9e87ab10f44ebac608fd9f1d3d670df4c21cf7b442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4c907513f46bdbf89dc068cfb324a9832c81782bdea5e4527ef8b802c1d2f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f8bcb75699027a5c1b2d902c1985bb903c31063199a24400935dbe051090d2"
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
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
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
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

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
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end