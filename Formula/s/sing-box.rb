class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.23.tar.gz"
  sha256 "58b41bd8d6255c2ddc2ae5eace53171e550c9debaa8e16d89871299055b58b1a"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4882017cfe554bac7db0c721449253b917c439305776ef79062376d75ecf0c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3970a3c856e27a4d49aa6f09de715cec638bb4af23281f2e1cb3c6bbc2dd2827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f01c33382448f985a0dc3a140e9c94cf8d508a57c25a162fe7e65aeb871568c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44285df78142211f0007197dc0a29fe7eab0147fde28d0cbd827c7d74d1666fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "112409496dcc69bfd0c3eb0a00becf691943c94fa74da754070efd632055f6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43297848191939644bb6c0819eb8db1ba4246020aa27124177334f18aec136b7"
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
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
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
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

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
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end