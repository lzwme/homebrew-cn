class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.2.tar.gz", using: :homebrew_curl
  sha256 "0d9b947817e33d8a965c1367f623cd3b8dc415282f9e4d658efd2573d9fd7cc1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29ff59f29ba7bf0fc77b7cab7355ddd412cc8b95ad2f712125d1dc160c0cd3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "243a6bf2e8f39151ada7ddd08b62c07b723d77c59c485004176f37770ab824ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55efec98b6cdaa3a1ba289df9df340972fa9a2ca66f780ca7ab854e9871fcb1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a90ec23a636b50059df746da49e2087c2fed6c22a943ab2930db9a6fa28bdac"
    sha256 cellar: :any_skip_relocation, ventura:        "5b876d311fa5b16adc3d20aa27aa04dbb259be4e9eb3fc21ba878f8b1d5f02b2"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b90f1085cc57422e8f608d6d68aadf9447fcca55ffaf12a93c6eb33ef1fad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9382af46e2859f5258b102502a463434dcea1059b539e5147b5537439dce3109"
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