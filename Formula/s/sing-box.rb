class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://ghproxy.com/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.2.tar.gz", using: :homebrew_curl
  sha256 "74bbe97b0f8df19c1196deda4ad53edc75c57259f51f88391d66071a315829d7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d057e096bd66fcef6d5e70c81f676cd73894df7ac2f1c8bc47996be1677efc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "898b6c5af5e169375758aa089c4cae8980851f479d6d1a758fef8ecbc083e6f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d48028b83c2442df3ccd2aa918244fe8fdaaa8b33659076b919565691e8bf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a9221572063da1298d2ccc34d9986aeed3ccd9528916782e40bd63e4681f9f"
    sha256 cellar: :any_skip_relocation, ventura:        "c94b9eddef87984c15928ef8e699c939e289ae33850ec5a6f5a5c8ef2d664ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "2d7fac48e34ccdc87380bcb3990658460c59530fb04a30d659262985c4d10298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22abc25e4e0a6eed1982964c18758b9934bd077ecfa5c534b70adf0d78f137d2"
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