class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.3.tar.gz"
  sha256 "51b189549395c132dce781e1c70315e4bb8386c207e171c07124759b45481d97"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcdfd88798d058220e1d638c20b4836b6936913330d3d22d4208e5bdc281c29e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93eed0e86f32ee1a2e29583cc6c5213a17089b5d0309a89f1577ddab2cc880f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd2ede065deb4c045a0596beccfd375076400b100244c4cfcd86a1f5ec460265"
    sha256 cellar: :any_skip_relocation, sonoma:        "921beadc6135f7bb2ea18cadf12284b7df4c5c2f9fb40c630e1fdd315768f974"
    sha256 cellar: :any_skip_relocation, ventura:       "da1aeeafc54e07671c59e32f79d4c236621f11edee1700789e006161a47d61c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdce5cc5353341edb6887debcb34e9744cec36e0792442fac92f1b7589ddc95"
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