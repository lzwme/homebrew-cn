class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "3dce8ee383655908451f7f193714f0c8f90b8fd4baecb8e7e3948d263d766359"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e922ce72b1d117796dcae77807fce2f422f6cc87597540184fe0eb82772e0b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed1e1b8cd0326ab8b050e193b197dcf2d1edcc10b176e3168acaa1629af193b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75f1b29127b7dbe82edd56e2bab6b4f79e2358b3281d68c7d7717c38a4440278"
    sha256 cellar: :any_skip_relocation, sonoma:        "067ae2bd6cd973460fc655db5d86628cb9c336968a40a26cf4be09159c7b9903"
    sha256 cellar: :any_skip_relocation, ventura:       "bf66cdfb3ec6cbfcc9b66c38694c4ed1cbda7b53b427014f923c0e7f80de66cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dcf5e97b282a59b85a64459c461cde7cbb51349345e399a1241cb984abc3594"
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