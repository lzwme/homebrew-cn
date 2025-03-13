class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.5.tar.gz"
  sha256 "ac95287a65ae9297aa0b9f25934ead8468bf7ef3f9045e483659ddc400e758a1"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a870aa2445c2d779736c87054676dffa5b2779b3632b19d620f21bae483ff318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527a7fc86822bd8d96ecf299e5eb08a55b2f73ab47af33d334f829b082d2876b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "372ebc862f87fbd88f8ff28bb2d96b0f06ae2b9f83cbe5733513663e9439d53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "126ad15cf72d6469ffd7918047776ed43c3025dd53300d7392fc762cc9e64833"
    sha256 cellar: :any_skip_relocation, ventura:       "8c0997b398c48bdc9350dd79270be6d773dedac16b108cc5a9d1976b7118425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37bddab9925c0245b01c33c3872cbefd8423730ac799e99d907858a4ca0ee8d3"
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