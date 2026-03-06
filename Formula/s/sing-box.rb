class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "62624d4c11e318606b0dc181d1da4b2b4d7e110f67c6fb15e1ba14bb88377f69"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2789166c37110e165d876a6a878565d2d2a7eaf9dd85b1714b2c9ae226b8fc17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fac28ba18f21c7bb3dd6e7d35fcfabe6052689f4d10c45105594058ffce544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c60f8958d5a51d8c781b56c3eee13df515c16a7c857216f2e6a0d719f0de55"
    sha256 cellar: :any_skip_relocation, sonoma:        "696bd5e0e7c3ab7a80c3a67fb4145dc39c8120e8f25d75faf1e22c4944a39f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb274d5613d23efcc6392ff6ab1b58c16301cfe5840f1bd9c5e9bdce18e8cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e962cb6b0e313cba97e25fb1d80cb407c8713aadefee8f767debe1f9c0acf7"
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