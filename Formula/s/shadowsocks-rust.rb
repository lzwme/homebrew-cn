class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.20.2.tar.gz"
  sha256 "555f0680621d6ebe19eb6b91356068ca7afabf5ef502bbe2a85d779af03e45b9"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d13b62c6d9ab87ce41efe84b2343b4822d71f5648189cdef339a20f81883da06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7df0f0e47dbc98e9bbf2236c46f7558df6aee4fb4c24684888a69c71872d45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a100c73dd75f27d3bf137b342d59bfe86ce63a25efb97c5dfd0a506e4da68e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbc37a0d3f7897b74cca87a5a995c4372925aae030086b426816110a1e736c71"
    sha256 cellar: :any_skip_relocation, ventura:        "621f462208d85f67730c658c0ab73b13c7eed746586ed0135416b223310ac9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "44f498f5e557ca15788ff52f82f709c2991ca7530f473577d1efae5656c4ed33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e244042d968274bc5cc7cc4963da514175ea93afd574ebacf9294308728a6a23"
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