class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.19.3.tar.gz"
  sha256 "d2ba10b56ae54378df40215705be6a5eee1ca96f30f4c59bc4fa001c1d6f676f"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c26790c478515f3b459088113e4ec80d5d3ce93f2965daf0672a05aa63725bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d75899448d037aa7c4b0bea26337ecdc4f94ec1babc32967d262dda9772230b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4af51d59b8589f4e74b1f6029d709b8b31af33786057bf3fbf7be54bd26acea"
    sha256 cellar: :any_skip_relocation, sonoma:         "e10df9f81a4289856453a9f752907208bec0435c35f9c33a85893fdabd27f701"
    sha256 cellar: :any_skip_relocation, ventura:        "e20512d38b684117265ebdcb9c6edcfca40aee10d9804921e113cf77025e64bc"
    sha256 cellar: :any_skip_relocation, monterey:       "664687987d80903ca1f9c9c54ba33b8de7c0a2d8cb88f68c3d9e6b45cdc7a055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd19f7e7a1b9024c61dae1bd13bd12a5cb6b1b6aeaf0b224597f370bce5729b"
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