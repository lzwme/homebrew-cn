class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.14.tar.gz", using: :homebrew_curl
  sha256 "2ba7cfa097f5963ba304d47606e7a6b61bf881eb86cbed78fa6e4efae44a0a5f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f936ce8434148f0385d7bd89290e91cf096ef504c99806afae3622d84b5e4210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b9ae95233c5241e802b56d4be4adfce2db5c37d0862884c7342fede4ccd15be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7716f0fbd2276b4f6f15917d8ca9f9b344057883a0e493d72c662dde43f42778"
    sha256 cellar: :any_skip_relocation, sonoma:         "76768db097b07b7eb57c0e8e2ac2ebb4bc89ff823eedb24c5633ee8ce3a55f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "f07b6f13ed17e47bf19a3ec444a5a8584aeead5dbcf8b7f9f428b7b19beb3aed"
    sha256 cellar: :any_skip_relocation, monterey:       "bddce22175653a3e626f5692b271fd806d23d1dea3907b89cee6ff44134d568c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6828c1fa8e08fe65737f9997f40247b015c38a90b6d867f5ad789d94d2ea9df3"
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