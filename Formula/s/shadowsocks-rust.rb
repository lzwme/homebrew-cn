class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:github.comshadowsocksshadowsocks-rust"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.19.0.tar.gz"
  sha256 "080d2042eede744d2182ebb47929b504cd42ef8e0eefacdc5ece402f99328ea8"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0418adb9255fd4f6a6e6f24fdc9fa65f76e69641e4e125a58589ddfa10af3a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925c124d3595748b011bb58f42c220c84b027282a6e7786af7a4f072c2ac4188"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "929fedc1b264bbf65b43acc5d6f0c935f7e709374538d9363cda34c26daeff73"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b9d8bf26a6a9df324c2d9abea629af59fa504e66af983d81097c5758d0dcee5"
    sha256 cellar: :any_skip_relocation, ventura:        "8048f1e40d9a90037098f351b677fd59f806a0a0a311a7fb57cf00c412c84c54"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ce80c14738d2aea1b2cc428bedfd94ae120ce3a2a9097bba2c8377db404508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b724a95bbafbefca0590113ebf1eec9cfb23becb7ab021bd652a0a2b6d05ae"
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