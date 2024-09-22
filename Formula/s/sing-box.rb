class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.9.6.tar.gz"
  sha256 "09412fcc7b3a56c325886af090fb88b2cd8a61984856da43e2d16ff203f3a267"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e15943214c500b01dd3e31d5b3a562860287de1a6d46445713685ba02fd33c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2db37bb6525dab44486679c451b2f25915efc6aed2eab3c89d7fc08a907bd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c85b1ed450f60451e241f60508318cdaed0d3c5fea098a0fd6c63513b6fa1cba"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d6e7602fedc708b1cb50336c17df02e0b23f76696ffdd8cb1f8c669e67bbe2"
    sha256 cellar: :any_skip_relocation, ventura:       "c99562b7ab549ad683413cb172b9eda76598464a2eb273d0e7f6634f1467ffd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bcbe136dabcbbce4e4788d5ff771d1cbcfd85d68f31c595afcda30b33fb3d9"
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