class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://ghproxy.com/https://github.com/Dreamacro/clash/archive/v1.17.0.tar.gz"
  sha256 "cd30a27f801652151eea129e9cb00e4a3ee28d45982dad835f4546691796d9d7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "609acfdee560b9a713215d1e742e6f6da96d3d0b262ebd3667b0beddc9da2a66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609acfdee560b9a713215d1e742e6f6da96d3d0b262ebd3667b0beddc9da2a66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "609acfdee560b9a713215d1e742e6f6da96d3d0b262ebd3667b0beddc9da2a66"
    sha256 cellar: :any_skip_relocation, ventura:        "fcab5fa06d99da0ac3ab33c26a8758de2faad428fe6b71e32b6f460d53a805ac"
    sha256 cellar: :any_skip_relocation, monterey:       "fcab5fa06d99da0ac3ab33c26a8758de2faad428fe6b71e32b6f460d53a805ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcab5fa06d99da0ac3ab33c26a8758de2faad428fe6b71e32b6f460d53a805ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87dc3c69a6669f8d4116480aa9b07a33f6c0929fe1cb91f7b0ea8fae8a900563"
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