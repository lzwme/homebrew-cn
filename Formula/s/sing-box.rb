class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "e8bc2c059757af705f8e96c1909e2693f79a4c5c573464529af95c5c93046f1b"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "763515732a4b6b2b0d6f2fc29cbe03c50cd847a604ed8717f2041f1d0ab7e1f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b431bb2e2d67270f0d46e7794862cadc260b4a1f5f6369fcdb2979f6db61c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c3b14234532511b58f723c2fda7062c0785391bb9dc0e96e63c9078396780e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e75fe64d6d2bdef91934e7617b9af592fb7136ec3f01c42d2fa4dcf26f70a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ce751ad0c7843b9f29f6fa49ebec797ece57fa04d461f38f54e4443ecaa760e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572715eb97cf434e4c6fa844ca4944ac67d1af58f354e072bbe9887db1840ae5"
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