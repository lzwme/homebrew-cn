class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "f19761d09f88e2d33aadfdb3c4ff471654f34b28561826e4786b9859654ca887"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fefe9f37379ebee522206e5eaef26b7423a7f680563e5096db93eefe15b77c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e011367a3b2f56bf8404e37a7cc528c81ac165e03b523c8e144624d7a2e270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ba719e6858441a84f6d18c172b8b419f60fc68478c9a808bcce36674de51e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d340a84f8006b90aedd9c3540c5e725e6ed63cbad3e343ede854c2577f31b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab58213fc7d3a0ba7904275184b9eb3270474c4c6fae6c7b5c14c6b67d7dd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1642aac4505870f485c34576c3a451e654ad6290f0858c6761c54457b7a1c7bf"
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