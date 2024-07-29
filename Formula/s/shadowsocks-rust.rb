class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.20.3.tar.gz"
  sha256 "07d2301cb14d8e1ff653def167604e701ca9a05a140291875e0ec9e6334ad513"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff2a3a538c2bbea3d9f261d403fa2725c81ffc15cf1c1a4b83e6a8328ce897fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bc34afe2c5bc80993f107bc284dbd43f93a2607fe316e6546da104cb31b117c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1564a01dc0ed86615e7f4a116ba16f38ef1b48b4fc11ae393a5b177fcef996e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5102e04bd672a22b7b61c260934a9f8a5c2e81c5836b49663204e2d98d6696ce"
    sha256 cellar: :any_skip_relocation, ventura:        "ce663a048700904105865dd1ff8833073793f5f944b7640a870b57355f322ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "fca1c4180ce9e579885bf4da26e408235ea4e4bc9ca063f207c77459cead76dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9332f3cf09d4f4075b7c54661a8059e53a286657739e16133367524ffb3a4212"
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