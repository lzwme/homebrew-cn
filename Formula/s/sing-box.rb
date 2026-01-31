class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.18.tar.gz"
  sha256 "8e8dbf94a4cedefea9cd72156c099eeebe57a3f2254f1c764a05b809778b5663"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8385a45f335446e96344166f4b01d9f642d3628f1c70e4ec99b2f401d7489e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9009787c717ca482cdf60bc6e9770dae2662705b24e8bd1ba317d9661860420b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f963bf14e1390eeddd4d2a4bc44b58a01e2dcf700ec436c379cf840b730b4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7247d7e20efe844a3ad135b2b3898cbe0be2eb31047907c969c405d802ace2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1159565f041672c5e3febbf960e94d5da8b9fbf0df582d5691c51e0bb7e7c42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bbd784aae6aaef73d018c51eb45686cc93c24deaa04c8864f2f6972e31208d9"
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