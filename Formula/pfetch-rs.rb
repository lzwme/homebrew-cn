class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://ghproxy.com/https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "88e0572a313b6d7405f5635373f1816e77c1228d9bb28e322ceb0a7ae399b06d"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "954ac9e43d1f4c279fac0cdb1ab87fe40b69e9fb2e427e1d53d9cd2487514361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34d607261e57d33f16c0f651c4abbbfff6422b3a2e96bfa619372f5ec3ed6ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11bd1853a070e7a718974b0b8f89210fbe926defa4dd12d4205fc175357a919a"
    sha256 cellar: :any_skip_relocation, ventura:        "98ea11d009d8b8052ec62aed11857454f1a78a01466d4ecf7f9b7852000e53cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2112e120dde16cc9e4e2931494473b3a384e22c6d5626793a15aed9b6472a0a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "04cc9d0df518ee70462dce3e852051d15c9daa53e01cc9e588470c70f3894a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f902d8d8321d89a73ce4e95381f2cdc84d7f9c41524b4fdd2e8291e020953b7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end