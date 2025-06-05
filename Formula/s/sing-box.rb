class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.13.tar.gz"
  sha256 "903d61cb1ae3b4782f294e2429ede8c6929d764e61c04331fcc448c28e9adbba"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee804c3030351aaabda149bfbdae9512ae5b31957a5090cec19806c8dd8252e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de1d260f71a09370d7e518ae733628e33f3a0ded982b9c18c23638a0c52947e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c896b1b307eb60d433aa36ffc43e4b8725c1c29ab81cc5b4f11f9b3907fb4040"
    sha256 cellar: :any_skip_relocation, sonoma:        "2222292e162571348020e6c66681debd83ff721645d1c319bc9a1aea4ef52815"
    sha256 cellar: :any_skip_relocation, ventura:       "a2e3c23df05276285d3e4735e65a9bc9ce559220a14824727555787f9e095bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7795e3be0ba0d4f20a9d5b6263689ac5e8d054ae8f75df78cf27f5ea101aa6fe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsagernetsing-boxconstant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdsing-box"
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