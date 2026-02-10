class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.21.tar.gz"
  sha256 "31581ecc92d75ed29103df636ddbd93f2c2f350104d82bba58c5e8ecf94660ca"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59e7313a6fc1101f3e6b32ef1992b70286b8809765fee8d44ab8fa006090da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c92bbbd63002e5668d0eb8f0a9aa92d249ba2b02f3eda2c57c962d9e235a62e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa8c2a3bb15cb4830cfb03a6df5f42cfa3af118f0bc328b272c4e88adea44411"
    sha256 cellar: :any_skip_relocation, sonoma:        "34571075d1f82aa7294c5163ef1296c93fce2ca65d33e6653c45a1f604ced5dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b1c7f2b23ccb582038b512a557087e92904479dd7b106b7932b3f76644f72d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7912869f0fad369d7c336720e7a0d8a79999253ed0f948aa7cd927bab5067f92"
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