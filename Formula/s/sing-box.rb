class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.7.6.tar.gz", using: :homebrew_curl
  sha256 "ef048ad69589f7d3aea3ad882befe25eaf1a1f9e04d9ffdde4b5215dcbca5363"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5bbc3e846daf7cbd37bf88e7c9334313fca1ba5e2102754c000b1152354371e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae8c9d494be49e6a5ed3b9f1613d53620c0fffcf677b88d0e3bd263fb7d76b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b47a56c600818560f55afc46ad43973332187cabd58b83aa58939f1fd07023"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c7da13cabaa956e1556c14cef16b8e7921327b07be6aa838a6f02a775c0eb00"
    sha256 cellar: :any_skip_relocation, ventura:        "0c79febbc176e2511191f6ccc3a414b784ecfc40a1088d46370b86affe656d54"
    sha256 cellar: :any_skip_relocation, monterey:       "986891958f0d26d143350fe1f67ba0d269d875f90712a4524c80f017887af973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873b5f88453bfd2fabac261aa79a76fe26167ea9efda37162f88db67a68e53b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsagernetsing-boxconstant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), ".cmdsing-box"
    generate_completions_from_executable(bin"sing-box", "completion")
  end

  service do
    run [opt_bin"sing-box", "run", "--config", etc"sing-boxconfig.json"]
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