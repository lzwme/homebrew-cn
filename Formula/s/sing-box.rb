class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.10.3.tar.gz"
  sha256 "93c4fe679988a5414e45886c66f3b969917aa1940bb807f2e0281fdaf4fe27ef"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5caf83e82c42b7177131ea3571f270b2e41b50fed8933e556c830e7f30a782bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27cab12055a538b47c61f00b735059e48b6487c45dae555e52aff9f3a69c651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "646ae491ca45d9407af2478ec32336b8e319f6d0bbadff2e5481022af722272f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dabe4bc16f04c589ed8940bb1c0f24948adb0be74f5fb4768a2dc55e65463a1"
    sha256 cellar: :any_skip_relocation, ventura:       "86261444a2917af4483628231c9587041997b8dd2b9f93804a5aeccc894acedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f14d567cfc94e390410b90cc676c2ad9a4af212967669603f21da5daadba24"
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