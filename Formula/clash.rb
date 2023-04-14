class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://ghproxy.com/https://github.com/Dreamacro/clash/archive/v1.15.0.tar.gz"
  sha256 "156ce3f7d7ba7044fa6ac054f5b8b2a1cfd21178828fe730ef12b7a6c626328b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1dfb702c3afebcbc1d6c75ec5f072bb1bd7ec4e2de65a3dc57cbeb3c2cd4072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1dfb702c3afebcbc1d6c75ec5f072bb1bd7ec4e2de65a3dc57cbeb3c2cd4072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1dfb702c3afebcbc1d6c75ec5f072bb1bd7ec4e2de65a3dc57cbeb3c2cd4072"
    sha256 cellar: :any_skip_relocation, ventura:        "b1297f9712a7881d4e081426349af21c132d194b913b346a99a5340fcdfd3248"
    sha256 cellar: :any_skip_relocation, monterey:       "b1297f9712a7881d4e081426349af21c132d194b913b346a99a5340fcdfd3248"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1297f9712a7881d4e081426349af21c132d194b913b346a99a5340fcdfd3248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935f3904bf744ccd373c815ba5a6b322002b65b1c147899ad8eb5bdbc5739f41"
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