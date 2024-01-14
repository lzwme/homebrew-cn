class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.1.tar.gz", using: :homebrew_curl
  sha256 "6ea56eb52c2168f3d5ac98ab1bb758f109a411a5a897599e60eaecaf8f8fdcd9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ede0fa607e16235542c58db98709d88b335e7ee9c2c18d108431d5993244e3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d4906108e23c98ddff7e72922ebc595c866fb1c30ddcb3bd4bc8385c3b64e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6c2570325dd0e3f985695bdbeef7b54ff5df63c4bc1890d4d606d3d79f1bc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fac35ea3235f2d2dd8b7fa33e140cdd03038fe2ded70fc5f7e5f811906594447"
    sha256 cellar: :any_skip_relocation, ventura:        "b3a7bc70db65374085ef36b489fa2bf63b8859cfdd09764086d2e425ff13348a"
    sha256 cellar: :any_skip_relocation, monterey:       "247c5c4b9761896a8b326512fe9d44ef79fcba6dd27664a251017dac3be0d4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46765d8267b3a49e6c4a2ea511d8fa3b6b3b0705a1b38c19f4f84ac12af504a9"
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