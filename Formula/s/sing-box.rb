class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.2.tar.gz"
  sha256 "cae964985e6f27a1ddefc074849a950437e27ef5bfb44847d5ce5d5b2a1b7a27"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9367bf8a052128d6560365c6f549dacdec36816d0bb9f665ecbb43cf3c45a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb8721faaf320212c01ecf8a5f01470a9eabff18ce6d9b9e71907ea617fa248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d93d2c23e8bee9d9336297b0840595f26999e62e4443d7d333ff4069c9a16b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d4453475dd8f48fdea15f4a8d61eb3da952797abf2d201bea183d7a44d3dd9"
    sha256 cellar: :any_skip_relocation, ventura:       "af72134d8070883ae2d0cab2a302735e5d556b948101daefb57a5723f32d0487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8559f2c3eac82dad31f07e9dd02b4fe35ae7065ae79a859f1d7966e8a77417"
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