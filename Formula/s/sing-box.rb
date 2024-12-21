class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.4.tar.gz"
  sha256 "0ed67ea970f7fc606505bc26280f0f01db1a0ce4c2ec44bcdfc848bd8c37471a"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e076c2200a3cdd4a0f5c68a6dbcb7e48ef0019b7416ec1bfd3a1b7cdb8b209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9860737a36620ccd719dec88b2bf4548f961e0afca905fa34158c6ec786cb922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61746ac66c2bca72385701fa74f5ab2e273544ff04b704474d5c2e8fdeb9f29e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b118915549114f4bdf52a546321c68360a039a2d4dcb14ce42dc8b4154944e06"
    sha256 cellar: :any_skip_relocation, ventura:       "987db5ea0e3526f5ecd5123ccd3a992e1c5ccf7d323bcae89d471a4fdfc5bdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4450dfd9ff18942f3bad8f06ab21c226002b300b20f6a6283e0ace36d345939a"
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