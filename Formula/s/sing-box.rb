class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.6.tar.gz"
  sha256 "01b697683c2433d93e3a15a362241e5e709c01a8e4cc97c889f6d2c5f9db275e"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce11c06a453318711a2b7e7ca921a9a9bc39c76eb8d9a1003b1794f4f38bddac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffba8bf2423813dfb13f89563248a321fd42c123cb3072eb6000331d5ee9e52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bc7cf43b66b20503de623884b7d79998250b211bf7b9d73e999715424a90e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e54e822720aa3c872e9675c8134df1c2dfe996d3465b5027287e21c43544ac"
    sha256 cellar: :any_skip_relocation, ventura:       "c8e8255c99369ebfdc63972697d2e505e89dff0f2f1d7cdfb100692410ba02f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d476ea2caec5377a92be84690afc07fb93711236e2b345ae143eb95a992268c4"
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