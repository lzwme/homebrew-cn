class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://ghproxy.com/https://github.com/shadowsocks/shadowsocks-rust/archive/v1.16.0.tar.gz"
  sha256 "cda512dcb63f9b88ae678dbb357e790e13fe8c2fee9997ea2a9f88677064bf19"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14c417dd58951f805be8c047d6f68f771636ddf3448f0518a35d2e6bac51dbd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf3e75b1b494cb845d9c1d5ca7f9e1de79b0218dd950900cd408769e626006b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7a9fa785eb361949f8d9430331a01633896e8c2ff5ae09dabd9a5402725dbd"
    sha256 cellar: :any_skip_relocation, ventura:        "db36aa3e08d8ba8fc9ebdfb5b82bcb5df3f5647fb2e0f02c0dfc12f515fa8b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca9a0bf16df20bafc8514955390cd0114deb772af304b28d98e72553e56952d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e22f9469702830ef1e9aab21b4a9a416528b68ebdda765a67bb2c5c6ca354853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ffd7da1167071c90befbb2b5e2d8aa4be98158d6113763b34b6a64d5929c7e"
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