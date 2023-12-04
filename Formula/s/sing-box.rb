class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.1.tar.gz", using: :homebrew_curl
  sha256 "e1a5d7c9a7f3a23da73f4d420aed19c8cc5f9b85af1e190fe9502658ec6fac3a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22d8dec18db4c02346a0945f47f66c32569cd3875ef4ef411f9e5284499bf9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19662f0dacc90b5a939ee156e91f3b741e406e1f50f822db3932747224b9a3d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d24055141169b1399df4f5e4ee5b2bb92334cf2c13f0bcdab1060564356511"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a61bd86e0f1bbc9706732e2f0136d7aab2b1b26f786a1f9a68bcfe2fe15bcec"
    sha256 cellar: :any_skip_relocation, ventura:        "cdff26054bebaf881b939ecbc9aa76148b85688105acdf2361c328d2422aeeee"
    sha256 cellar: :any_skip_relocation, monterey:       "da80d67585776bc020683f335e69136853b5e0f5bbb8f01f45a69dbfcfacb0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a184eeb91a0684c14a3e337c488d96476a9664a398d92f496efde84cb226bff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~EOS
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
    server = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~EOS
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
    system "#{bin}/sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", "config.json" }

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