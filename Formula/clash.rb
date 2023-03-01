class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://ghproxy.com/https://github.com/Dreamacro/clash/archive/v1.13.0.tar.gz"
  sha256 "dcef53df90d39e150f8da2f96edbf09d29b769ac89ea968699189f3f7ef15f60"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3d32bfe3d5462eed56fc47c69e651402656c5943bfb8809272eb333b544e067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad474b40fc6bb4b7c87eea82f4226ad1a81937384645564391b54afbae3cb66e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0374f8df8b17fad8d0954afbd54eed5c6a5f3a3ee8f92b120cad84fa04baa9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a2c95bc649a2772bf6cd394bb9e38e4fdc2f6d97b823c84b4a56d5c730839306"
    sha256 cellar: :any_skip_relocation, monterey:       "7df06b362de2dab4c2777236e0af43630eff6597c300053e042e052a28630874"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e256cd50589906a83f05cf0bc3bd47ffe974cc680af5ad675b8b0b502ffaf2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be4808c4f063569b05b55eea9f566b5e4120f7cdb103bd97746bb0f019685a6c"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"clash"
    keep_alive true
    error_log_path var/"log/clash.log"
    log_path var/"log/clash.log"
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{ss_port},
          "password":"test",
          "timeout":600,
          "method":"chacha20-ietf-poly1305"
      }
    EOS
    server = fork { exec "ss-server", "-c", testpath/"shadowsocks-libev.json" }

    clash_port = free_port
    (testpath/"config.yaml").write <<~EOS
      mixed-port: #{clash_port}
      mode: global
      proxies:
        - name: "server"
          type: ss
          server: 127.0.0.1
          port: #{ss_port}
          password: "test"
          cipher: chacha20-ietf-poly1305
    EOS
    system "#{bin}/clash", "-t", "-d", testpath # test config && download Country.mmdb
    client = fork { exec "#{bin}/clash", "-d", testpath }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{clash_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end