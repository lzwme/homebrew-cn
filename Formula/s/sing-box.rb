class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6ddc71596dc937873c5aba15a4f2b395c5434265efdc1bd21f4c03d8c5b7f641"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2879e6ac62aa2fc2ad291a8ff5dabf9c78c03a5bff3686960d461e837180bcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36094fc9c1374d3acea46ce376981d4dcb10a3e6d7cfd241cbf443ea67fef447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a21d5945d569bc8d9e412183e3c8f81d3819e59a8b74500560fc92e39a6f12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dc32baba1c7677ee7208b2d6a41b6ab5b0c8a5ea544ae04dfff963d745b9bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef8bcd13d5e5754a0294930fb137e3937bf8e88797588a4902e6086e99c5dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab6e25d612b8849bd090a2add59c4ef0d8159bdc533da090a446ad8ba430c27"
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