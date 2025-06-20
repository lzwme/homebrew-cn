class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.11.14.tar.gz"
  sha256 "0f68f46f979d9622386939bafa2adba20acf8f371f5c448c69154770c7759717"
  license "GPL-3.0-or-later"
  head "https:github.comSagerNetsing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5be9cb9bb5c720ce29ae467da63b9fd650b12d058493fd78a95c7bfd86de4745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62af042853a97ee1c5fcdd0166b96198f3071531283147df062280feb325541f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bf102594aff1435b52cbe7311c3e03e4f733b33a44cdeeee3feb2e4404ba7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2b35d6f88d34ca7a81af9797a068a3acf0f83f8278dd4945079baaeb08f883"
    sha256 cellar: :any_skip_relocation, ventura:       "312b010757c579b2f7d8035ce8c00e7a508b90263a4593c59571e8d3bd889124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1d6c90a3c1ce2dd0864ce177b4151a60e0353bca21acffae703961423714e1"
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