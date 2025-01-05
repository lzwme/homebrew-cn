class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.6.tar.gz"
  sha256 "bb3ca59c848f1509d0e183c54c91716993ce77ab0c9c48a0de0bcd4cc1f0e021"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3031ded03b120bccf5bad5b1f6bf6aa0e93783a894582f6ba4c5a80a17755a51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c006633cbf28d9a6ca4e9b470b213b46c549980052898599ffb23db0b9208951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5192357b96823272f7bb78d2e023f0ecf24f9bfd9729f3f2dd61d0d8c4a21290"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cd12d0d77f18121779e4ec1b152aa46ed44eb8841a3ac68a8fd0677d30e7174"
    sha256 cellar: :any_skip_relocation, ventura:       "af722b059b98d36bb40b1e5ce59a6c69001431a65da2a0b95510dc9bd03e219d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ae4051adc87b7d759beddecea9741c0b83ef0fbef52fa61e4c3c7d89b15a97"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsagernetsing-boxconstant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), ".cmdsing-box"
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