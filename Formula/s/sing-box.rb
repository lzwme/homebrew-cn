class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.6.tar.gz", using: :homebrew_curl
  sha256 "88c8825f6e8af2e46a16e8a85ceb5e1c7c0795b59cad93c8327288ec7b8249e0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99349dc477e3db487fd108831e4bf9be1ab7fe70d43810439f9c2aa24c463642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f235b907c34b4fe006547c9d2313bea3920694f51a0d5522ec1b1ceed74ea007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f27910243a7b4e6d95e545bf592f232a3e070eb7d44dd77de20365026d20a272"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d8efc84f8aa4d86d4d7d5df4ecccb8f49a971e3b5c454fcb77da2eadc182f93"
    sha256 cellar: :any_skip_relocation, ventura:        "2a64861606e03d0f62e651f51926430512b329585269840e6c62be6b12556aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "9dbc19e6ef4228a7b3f265936292a5f0522cd5d6bd63b0304c3cb0f5519ceef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f1482d3f786a06fac3eb3d842e82f4c0ab395565809f4744b165bd84da4179"
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