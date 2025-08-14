class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8c7de6f996c9d3ad363d60b52828dc649a579ae8a5f0b596fc8ff7ea7622908d"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8308cbcb0e270a1a94c8e7f753d0088ac11f4fea16d74610c854344401b3af72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8ae77fdd1fc216480a8adc433955dcfad9cdc50434ff928a8e0e298432a0c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaedfd7440167dcda704ddb7655e516e71c8c49e22be3be01e92475b76efce9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "567dad60b7c1c07a96096ba4a11d9224432a5db50bcd9d122b9d3e510b6be30a"
    sha256 cellar: :any_skip_relocation, ventura:       "f04a96ea728b519122129c4d2b964760d656c3a12774fb522d59032e1ef4fd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4121beb2f4dad6d2046860fd8edbc7f140d524c70a22824aa7e314eb69c56b"
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