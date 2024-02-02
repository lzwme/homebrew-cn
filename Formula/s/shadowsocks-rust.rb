class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.17.2.tar.gz"
  sha256 "79d3d5204fad725bd2712f29066e71d14a329c3ea956b708cb6ea64bb0316a0b"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cd450345838655f936c3946138f01373541771e1ddf3dc9e36b8798dc636ad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb5f373a7e1be230c782108c3e15b8c78a5b68117a3eda59d374e177cc23c85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "143e910ed2b99c5f3cc825541acde58298fa2068c9b3c5a908cad8e7f28730cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a80e16c1bc343a38a149c8215aa7314bef7f6463667e3c841d79204a209827ac"
    sha256 cellar: :any_skip_relocation, ventura:        "43f59c7ed7c8032ac0aff074a6458734373c19e4fb80d4c8f0ba21b869234377"
    sha256 cellar: :any_skip_relocation, monterey:       "35fd66c991477499444dfc3b70d8b375b3aac1ce8875da7d3bf54be845e1dd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b214224f60576faede51163576c0f2c803cf1d72d27e3b53be27866c878bdd"
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