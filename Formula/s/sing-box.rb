class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.0.tar.gz"
  sha256 "d4a48b2fe450041fea2d25955ddc092a62afc8da7bb442b49cb12575123b2edb"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ec94b769c0a4e373a7de4efa4056905f3ae81f863d8b95d6cd90c5331d77f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dbf12a6923c44e0ba14921d8082306be8aa4b628d2b6bb6499c3d4f8f33f5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25ff6461bee03434917ec91a9a04bee833d8edafdc9503f0af014fa00da48774"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f49bb43da20b277f54033066c9a520a5a9187f7cbbea8aa1b40bb1aef47943d"
    sha256 cellar: :any_skip_relocation, ventura:       "7dd3e3126a128f399b7ef567f6e61e13cae4fd17283ce89d620db6f34593435e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0040accca0088b049bccb25c87c9284725747fd1e7c9aa6b34599e95040234a9"
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