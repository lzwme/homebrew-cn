class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.0.tar.gz"
  sha256 "eb7af91189122bcb748912e205cdddb8b434c69bea67cfbe1a4082a577380814"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9ab25addacb4fc30d86e5f2425068e58e8ed860e3d398697aff6411fb7ef7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82cb004a3bbac552feffa9f47b6d8d259180a11e63059a1b890decf34885e109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6670c58e590b460861b7983dd06538aadf22051e5f68088612bbce3ca163cf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "48feedb531fd61aaa8b2bd4a0d914b8df255c26501cb763d42261a86df247df9"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0da4a6b9df4142554aa50145f7c4433e84f872d438e2dbf2a328842af28d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3278b77c9609d6451730768884500a115144686b31c4b9225afdb438957e4d93"
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