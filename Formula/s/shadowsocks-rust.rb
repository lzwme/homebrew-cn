class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.21.2.tar.gz"
  sha256 "a2269e896a27a183dfd6d757d130978b46e1ac19f936c4229188d017b7ecf867"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee2a24aba83f9533e2c3dc0242bac48491f0899fa85a509e0c58e4d255fd8d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783d1c6e4315eb448e6e3e3434230d159a61b948fa2b9b1afab3cb792c65f43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4db87dc876e904ab883fb0d928069fdff23a207545cede652931accc2f3f29b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c80cbdba9d0cc2eefdcb1d42abea4b6df70c2016a5ecc48daa91db704b0ea3c8"
    sha256 cellar: :any_skip_relocation, ventura:       "0fd7afe90bce3856f4003ca758fc0e227544f14f2b2b0dc3f5f569a70382188b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fea59362a047a2dac5a646f7cec88d6f5b45a6fdfe02992898cbd24314d871"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath"server.json").write <<~JSON
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    JSON
    (testpath"local.json").write <<~JSON
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    JSON
    fork { exec bin"ssserver", "-c", testpath"server.json" }
    fork { exec bin"sslocal", "-c", testpath"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https:example.com"
    assert_match "Example Domain", output
  end
end