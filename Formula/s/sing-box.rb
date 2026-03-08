class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "04b72fcd355c36a85eb028f47986894e9cf4dadbea3fee79f6891481cabeb692"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ea401895bd719fdfd30412960dbea603c1a9b849d4f475aaa34ec3b99673f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7019e52782d415aadc1010b57ffcb86bcfd5decb2a40a37ecbc25eefa7017473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f2defe5f1153aa8aea5f50fe6505f97297e5ab99d0399fa605c0401544abb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f4d436840c5753894829f349f44f00c3520b0403893bb7f6fc807be9f686b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee193c6ccb85617e0fd706917ac15e9e6d2e5a003f5e713b8a47e4e03621d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af46f301c298d1105abde402c3b8dbe496944480cce3335da96ef14a7d2c3e09"
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