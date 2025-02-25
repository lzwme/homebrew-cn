class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.4.tar.gz"
  sha256 "633e40e2a64937069ada9d8d96dec1a5d735095d44eb3cbea105ee05f4616fc6"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda237b9c4c7c9161ef939230fec4f79ffd717df86b142936d6aae54b8c78ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a936ef35ee1ffc7813e9b2c87565c00151400461aca45fa184ef6d5f3f5df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "236a4a92e40fbadded39520c800875d930d67f4024b1910af02faa9f630ed9b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e1ed975b2584e8680a9256acee68c1a3c77a1e6bec10232499c3689905fae72"
    sha256 cellar: :any_skip_relocation, ventura:       "4507ce47bb4a0519fcce95db541d2bc53e56e820381651e3653b7a6c222f76bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2706fc79378bbd6b8d8000fffff0e8d2b8772a07891b1bb767630462612bb61"
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