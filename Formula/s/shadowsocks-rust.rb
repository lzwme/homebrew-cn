class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.18.4.tar.gz"
  sha256 "1df8961d4b16f756081a554bf84ded124d43062f92cf36f2ac3f590ee72d22f3"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053f35bd787576270b15ac446718272347501e3441b67a70d10808b1d821a823"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa818b64dc66d7c7a0ec9301b99a00caca012522cf030b6460d66dbd0d3bd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce3aede846d502a5fce7d571564bddfd00397ff6b13c9333672dcac42ad4f76"
    sha256 cellar: :any_skip_relocation, sonoma:         "9551589ff8cb41b6ed9793ccb47c01f3b1a47d19d21173a044a4877e23eb1223"
    sha256 cellar: :any_skip_relocation, ventura:        "798d6f950bf3bd5c2aee1eb881fb3177538b7f4a01f4e490c152eaf8ce5b4add"
    sha256 cellar: :any_skip_relocation, monterey:       "edb05d8b62f67b5851ad7a7167ccf724e76d2b25acd596816771952e783e6c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e2bf53d920b32fea977f7200e89ca727a33218a3969efa0b7f1a912562af5d"
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