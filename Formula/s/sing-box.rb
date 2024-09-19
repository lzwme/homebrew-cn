class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.9.5.tar.gz"
  sha256 "6beaa010c14881ba29ea147566c32614dbec8c3f8993529d08664c470e099195"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1777858cf3d6e6210c4f95757dacbee724e5c774b5c5ba86bdcf03f8dd258ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97d6ec81131211b73a1a7b491ef9a95e36889b29d732d1bbdd6b34aad47e110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2f1797c96b15bbdc25ef7ae353c09c27d6a5ed53b70a79b72308a4aac9f0f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71157c06489d761441c1c00d4a40b4d033f56f158ea242de5cd95f5e983b988"
    sha256 cellar: :any_skip_relocation, ventura:       "4c1e0d81eaccae8089e08121ab404cca4dbff83da13bac8ac089a94772252fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4de16af9d257a4af275f44cde01457991191947efc18818a220c10845ddddc5"
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
    (testpath"shadowsocks.json").write <<~EOS
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
    EOS
    server = fork { exec bin"sing-box", "run", "-D", testpath, "-c", testpath"shadowsocks.json" }

    sing_box_port = free_port
    (testpath"config.json").write <<~EOS
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
    EOS
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