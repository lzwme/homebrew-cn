class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.9.1.tar.gz"
  sha256 "ba5c0773dfed932c60c449a910d76d3157648e920defd75a8ccf24c20be50bb4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f66734a693720d444fc523086d522cf658b580acc7d205c4ae0f8d9be4c4c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0528bcd7e137cdb3855bd0171ef9bf1f5f2a07d4e45adfbe398485fa7afdff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd33c1269693e96df817a961fb7174b7eb20df7f48f8abbf0d62e197405dba7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ecf1ba47cde51413bf059b51712401ad13f2e7d86b098b415de067f2f534104"
    sha256 cellar: :any_skip_relocation, ventura:        "89bd9288eaecab7e83b13ee1a8e5478e9c10ffcd51e8c48bed60dd080952725c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3b1bf61a6355b4f5e6ace0327cfe9162f1fb9c723bcf0ef3a01d0e75c5c4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a2e75bf74db0c1acb2e25f6d9b5e8f7c07994925e5e847bb1430ff9acf9b28"
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