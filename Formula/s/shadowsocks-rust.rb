class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.20.1.tar.gz"
  sha256 "95bef16ced3d937e085fdce0bc8de33e156c00bdc9c10100778d3e3ff4df95f0"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afabd67e02ac70fe8f64a7e3ee39a794d08bcfc3c6697f5fbbfeb7b12667b9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db73da02b59928af38708f0d37ce817ef688aae06cffd886f8730ca963f677fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42aaf88dea6cf657a6e452f749c0ac8c4a5455726e6092e4766870abde2e0ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a9e43ff5ef617e9fba2f3ea47f8f01c1454babe349afd6dd14f22b9d6f15f81"
    sha256 cellar: :any_skip_relocation, ventura:        "2bcacc821587605c93d528eae92d1112615e1ff7a34fc582695195e2f47b4333"
    sha256 cellar: :any_skip_relocation, monterey:       "0babb67fafb0ddc7fd99cfa401ba035c9ab2315409604aba9d0c7323c3cc90fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0c91843d9e5137fb282d5ff3eff00f097c05df516698c06c2ea3ac7ab835a1"
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