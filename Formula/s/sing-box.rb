class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "1093254161d2dac2175a589eb0b43415b89b3e0c10bb2a09ac230f320d974c82"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06622317d1a2f90d384e8ebd5074fb6c5eba5be61fcdd95d48c2b18c214c142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483392a52ffb842cbe3e346f3ec295854c4c57cbf104d4f7524a3f6150b9cc00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89a69115727719310ab5d849d0e4c01fafb0189b59ab8e30fb45acbba5777d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d99a50ab64a41cc003549844408955a1c76b55061227c8f4a674d8173c0761"
    sha256 cellar: :any_skip_relocation, ventura:       "6f24ee85e92ad4f18329963c83b24eaea22b975bf9be6b7fe617359439e7c708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227ce4037b189dec13eda0094062b1192ee7ec242817229ed35ab642a8bb1d48"
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