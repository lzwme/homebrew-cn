class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https:shadowsocks.org"
  url "https:github.comshadowsocksshadowsocks-rustarchiverefstagsv1.23.3.tar.gz"
  sha256 "cbbd2357e9ec00dc18bbf437cf1ac88fcb3376c50ed579c782f372cf75bb0a9b"
  license "MIT"
  head "https:github.comshadowsocksshadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7caa8cb29b666108888b975e6ffc44d42af333653fd554b52857f6ec888aa25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc3247159cdb7e323efe9d0e91ad7e73badabbb618b407a11223f363d5700d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6664f615d37eb810265e88690d7d9f8699b7cba1ab49b66704623747f350d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c502b48295304b6b77b1d2429c62dd65b18625d09f569aefdf5273aaef631908"
    sha256 cellar: :any_skip_relocation, ventura:       "34ef9ceea99ca0fb3d15357f1250fef6f20fe9250a7c92d82840168ea971e5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e4c3717a3c9837af5ab174ec272d076a41c43558d6cc0608adef98654c99ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3912a92b37972d18bc00806a69901f92d4aa7dc24f710679cc138e592d4bce"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https:example.com"
    assert_match "Example Domain", output
  end
end