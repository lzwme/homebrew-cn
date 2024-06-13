class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.19.4.tar.gz"
  sha256 "241a722c7267418443f354e56f89f8790b9e5cc3ea6e286d37028a607d1fc206"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32d2839e69a06307b298b94ca986f0101d24317badb8ed1f9d429205f3003dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79abee6568b2912dbd86b14ccd2e745a3ddb4a8d47b4fda1257097179bea8231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21bf17b800b619383f5fdf7f0ca84fc63c75d01f713824eee343da8a85641cab"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd751df02f35b18e16f2aad88a1ae02015b46ac7fe20e811aea60383fb9c0829"
    sha256 cellar: :any_skip_relocation, ventura:        "e76592855f19f83121bcf00f360cfa85dcd9c6259e0a763f571ad1e5d3e14445"
    sha256 cellar: :any_skip_relocation, monterey:       "00cc8c9206fea19c89910acf3d0a33060c9f3938c0e2c2777b18812090fbd8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c160d4527523908acdc6399e3b7c6067782dd9db6570397353b4a8698b2a17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    EOS
    (testpath"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS
    fork { exec bin"ssserver", "-c", testpath"server.json" }
    fork { exec bin"sslocal", "-c", testpath"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https:example.com"
    assert_match "Example Domain", output
  end
end