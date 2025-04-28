class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.9.tar.gz"
  sha256 "ee0c183ed9c431a2b6b5f12cad0cfb1d2bccb83147b641d50a619a381fa9d449"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77975fc18359556b81a87cb694968e0cab5d90414fcff2a37c7fcaa66409bf2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96efc88a77879bd4ac071b22558773d37779259e7d069ad8eb691e2bce36d1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51ac8faec56a8ceae0845f5edb3f39f86bcc2e9ac56f000f181349c07d87f938"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5b0180902430f06d83b6504b1dab71c9a238372db51c3ecf76f4b674bad488"
    sha256 cellar: :any_skip_relocation, ventura:       "423bd470fc4e42dcd18db83d07837beb85947be8dc5fd3341e107a790c198d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2d3de9dbe46fb2c66d961b04f2ee6f253818fcc4035c502011972edf72d66ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsagernetsing-boxconstant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdsing-box"
    generate_completions_from_executable(bin"sing-box", "completion")
  end

  service do
    run [opt_bin"sing-box", "run", "--config", etc"sing-boxconfig.json", "--directory", var"libsing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath"shadowsocks.json").write <<~JSON
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
    server = fork { exec bin"sing-box", "run", "-D", testpath, "-c", testpath"shadowsocks.json" }

    sing_box_port = free_port
    (testpath"config.json").write <<~JSON
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
    system bin"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin"sing-box", "run", "-D", testpath, "-c", "config.json" }

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