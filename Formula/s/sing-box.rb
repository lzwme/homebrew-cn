class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.10.tar.gz"
  sha256 "476de60d3592e41ac1f0f4ae011c63b9f40adc4a6b4f8abe3c16593d3edf0d04"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6a67d501a68aa6f5b197d71792232a5c8845440ccf59a1e76d02cd372f6c86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc5d390c54f08f43707ce8bc208e1d11e1ebd4b72b37ca61ae46816e4f129fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891d4eabba20c84bfbe1b64f2281b0841a35bf95503fa837d48f309196c34115"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57585c02ad7fd8934dc00922f1ebb2b92db477f8eef0c7d027c7afbbc357b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0436a13623367e5b19b63792c1b14cd1a5337dbb24e233fdd0218bb96a69a06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5841042a1a2fd1e13d5e5ab92531a6976c55694e1d83b07ccf494cda77bf97c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = %w[
      with_acme
      with_clash_api
      with_dhcp
      with_gvisor
      with_quic
      with_tailscale
      with_utls
      with_wireguard
    ]
    system "go", "build", *std_go_args(ldflags:, tags: tags.join(",")), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
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
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
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
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

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