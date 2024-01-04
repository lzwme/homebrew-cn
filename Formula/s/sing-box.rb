class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https:sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https:github.comSagerNetsing-boxarchiverefstagsv1.7.8.tar.gz", using: :homebrew_curl
  sha256 "cea8c155699098d8de831a85bacac9c64f5a30eb8b6f36d656ebdd7fe3cc4581"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd62efc96d607b1b2817349f862306b58a8981a04d3d07801d07fee87707b2c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efb8e7e3977c907dfdc0988de2c54fdbabe11d574835c413447f8436c873c44f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ad85a85f31ef7dbe908c118f732bd5af737219be4a4364ef054026ee629425"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7f6a49b010138767a878a5feea5f2e06baadc4d1b719102d21fddd1d893d058"
    sha256 cellar: :any_skip_relocation, ventura:        "88f8d07af2096c94ff72a8771cbb457b717f1335d809f61397a4052c5a3ad4d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb2637536d3029c3092aab522e0db61315daac1a88916dae62439dbce73751f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04157765bb2bfac57b1027ea0ced9e89e3baacc9be7e4288a9822d5c596b5fd"
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