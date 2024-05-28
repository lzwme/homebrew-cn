class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.9.0.tar.gz", using: :homebrew_curl
  sha256 "cb1d91e362f4dd7c35f7bb040514414861a045a76301af8257134c65f7a45c36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52116ddc85ff73aceabfc0ebf81b1035de68e4ac90e590ebf393560edfa6d4cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "970b8359a25e4a3cc6bc68b08e8068bf46baef25b9739ec3f97691d8f4123f59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2982f69e1cf2d3804832a09e5aa7ba9521d27f309c8be9705b97595983202edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3188d64d0fe72e1036b8a95ba67415483327fbf3663c94c353dfe9f58349504c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5ae34cf66eccee1c8224420e71574173ec6e788773d6a4242c9dc93c61bd12"
    sha256 cellar: :any_skip_relocation, monterey:       "d4d06ce841bdc8a3e3fe9817eaec84f63acf781b391c442b3851ce6cdbdd035c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4232e70befe6a7dd93a6c3968c7ec3ec1050cb7977e1f7c3ea4475c05d9ccf51"
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