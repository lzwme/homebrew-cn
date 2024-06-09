class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.9.2.tar.gz"
  sha256 "c187867e7dc42dc5913acc791cfff209126b6bfccf658106a97d78ea4b4bee2c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a067a971a831bbaf148491acf790dd248bf9f77b8274c69e71acfe34f85fc8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0263371da6ebed660fd2623b7d7835b2250bc601e9d93afecadad869f46705a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f560579cb14ada53245c4bcdb936ecec7dcc42d90de2c5c63be885bf36a239c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5736cf996d87345391cec9f01f2759e1ecf95dda9a053784ba96ab602517f859"
    sha256 cellar: :any_skip_relocation, ventura:        "1d438b4c457ba6276b0aa9af98fbbd04b2c5005ca88cc80ceddb1b338ba4f9e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8ddef67376f0507609f4d4a1afe9c56467deeb0e2380332c4b7f913b14964ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f682bd1b63e31f1a028eb80dd133a954465504e46c3826b99831579cd4e95a7"
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