class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://ghproxy.com/https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "97a1c8ebf7fd19de94cd6d0dfee398667e1f4e131ec8a37ecb7c3191af7cc75e"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a99af7a61222c0b5cf55771984553d85515e81904ad669128f686d0709296ba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "034e4e9e55de0d11882a480d16a5bb0e21c32092ecc8fee0e5a8f2ba24f26374"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7325bbc5d2231865c1d5e2a73a8a37b404b9730ecd8b558e9ecc7d8e0dc49af"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e40a386df6819cf67a305d441b4dc78666287cf5d161657c33e958bc5f06f01"
    sha256 cellar: :any_skip_relocation, ventura:        "6873c86fb173427d9623cac59e410714c567409de239a348d926382ba22e8fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f1f53bd9cdbabd56e6274b8c37013f3d1ebd6a230f85a1ce95d270cdcf3ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da75b65e3695fc2d1dac8e2ed4dd45a1797bf12f7fa8aaa35bf55008ae55d4db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    EOS
    (testpath/"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS
    fork { exec bin/"ssserver", "-c", testpath/"server.json" }
    fork { exec bin/"sslocal", "-c", testpath/"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end