class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.8.4.tar.gz", using: :homebrew_curl
  sha256 "949feec1da2bc9d43b6c766c1dfb6f71f737a221e5ce4220616a3900dfb40c82"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26a985e124a44477a3b1ff572d6d0a49e80a5494f17a77cc87b507cd0e16b0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a55b86cff6bdeae1a275d94c9d2cc05fe635f5b6d4c79d731638d32236c8853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "864e1ce1acd97cdffd9e52457084535d0fcfc93eb4aa0286a1fa6c031604ad71"
    sha256 cellar: :any_skip_relocation, sonoma:         "924ae9440bab110a9b2481bc780a791dab0a7aa317005d8c3875f1aaecbf3c75"
    sha256 cellar: :any_skip_relocation, ventura:        "d6daa9809426a4ba0eb374590ae0d267d7fdfbe5eae3484af980b4728f6c655e"
    sha256 cellar: :any_skip_relocation, monterey:       "49010335bdde0a32f7b6a7523eaa1dad6d1ce66fc557a4437ce74ba8bfad3a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e189917301e319af1bbe981b3f482dbcb1c73565ccb6e1bae51875df587a5b3"
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