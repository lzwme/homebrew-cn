class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.11.tar.gz", using: :homebrew_curl
  sha256 "d6c33792c694b817ac86c9baa5d73a8112deea341d4a36c83fe782efa8bf3548"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7906a7548b0832a7ea9071726efbf1a291fd503da6ea6852ab1d8a9b19e0f2f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4fab4a903a39f4b7c67df01436f17c918c0f25fbd98e2f62549d9fbb183cf09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "022ef343bb7a7386111db865ef0a287c130a12ae23f5797b06ddffe4cdfdfe1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e715e1160c9a4a94432ef7b3e4d5c6fc52b2111a68e39b5331f5bb5a69b41abb"
    sha256 cellar: :any_skip_relocation, ventura:        "8adbb4b286eed05ccac213c9ce884b34c4b60e0ba7acab615208fbde4744a0a9"
    sha256 cellar: :any_skip_relocation, monterey:       "7547c6b060d8b6a479d63b94427406e8bf45ae889ae233486ac19fffb0dff71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906d5ab4769c8d0725b168bb389937cb0b056f46ab99da60f354c82e98917351"
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
    server = fork { exec "#{bin}sing-box", "run", "-D", testpath, "-c", testpath"shadowsocks.json" }

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
    system "#{bin}sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}sing-box", "run", "-D", testpath, "-c", "config.json" }

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