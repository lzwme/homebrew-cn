class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.0.tar.gz", using: :homebrew_curl
  sha256 "80ae2a860fc77d961c578999e5fcfe964f969c81d9ccac156b2fef1340eca12f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c71263994851e9ef1e9c6675b4b4d69cdf549ba99a2cf7a0949ff414bb1f8b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fed7d96bfcd5e47bcfab89996a786fa3a9b7f1464a5daf795f4d3a7adf4df55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7f5454e9e851a362452550e95d76b5009f0f54b22325ce080aa504a2321265b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1646b7fbe4343f5a99851460a2d81ba646e56daf6a4e16c2813118906baffde0"
    sha256 cellar: :any_skip_relocation, ventura:        "d6f6a7c297f3b7341819c1ab706126f4fc93302ac80ecab0f7e3a68e91d4e0be"
    sha256 cellar: :any_skip_relocation, monterey:       "3d31488fc7a852c93f0f15e8ce4b5ea379760985c7df42e6a42d4ae3b9888910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a324e2256511e0ad1087b558637ec4a875df106a313df24e78f9f935c64089d"
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