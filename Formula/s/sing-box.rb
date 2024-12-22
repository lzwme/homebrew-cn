class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.5.tar.gz"
  sha256 "ca0385b45d160c2c2a1d0e09665f4f04caac27cb3dd9d6132173316dfd873b75"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877dffd484ce368a8170ced3b60a24e4f8b61ee9d21343516f34b5d84c7f13ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70319728122cab3c6358aea05407f4eec335c473106fbb3f81f69269df159843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "264f810d0fff2ca59dc108e9ebb323470dfd6f25b99ad513d0ebfe4b6f990426"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b4ec738d49389b9c95cf45f4f5b4674c721c92adf5a91166d8591064c3ac92c"
    sha256 cellar: :any_skip_relocation, ventura:       "4848bd3876145772f97e888df53ed04dc1fe62567195a666d1ea78c920b03b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e747a95bd607c317513435cd4fdbc802a9abe9f3a5aa58886b4abf3e5778de2"
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