class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.19.tar.gz"
  sha256 "e122253d6712c13997b3aba9692dca5fde3e4d0d2aa606fd20913b772fcd147c"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0aee58737dad3d8915c5a6c0a394a2ff387ab748021d1ae4d319708056d78fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e52e2515896a6bf0c0af2de656c5bab8578de6f697c8935d9ec2ea8789df3ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b3eb08109086185c944d89bdc8afe217639ee1948204c0c11f88c0aac437757"
    sha256 cellar: :any_skip_relocation, sonoma:        "df13b4b25c4e6c5b8f1afb8c030f79920aeffeba6606a69f400c142aa2a24fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449d96c32f7040404b93a1449a15ee6c832f507963a85099e1f2db40db5965e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f2e8c42ec537cfe96fc094cf1f14e3facdb18fb9802bdfed3e554042b7a79f"
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