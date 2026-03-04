class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8253e16b5832422e613e0f0e089688cc20346ee297fa51737e9dd12e6dd75662"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "808e83cbc45fb453c34ebd1445ae3c99c821790023a6dd348ba4129dd6348fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79fc764aa11d15d77d122791fffcf1420a292d0028f9b338455562e429ddb5c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51127da676bb2d8a2fd1f2321bda1e9fb275323551daa8f35fd1de409a42de75"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2a74ec6f052c1147dbf78fbd5df8648a099188a44b6f8692be16ed1e845744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c434dc5e3f371891d5a5f3683606cb157186673e940844dfadf0c4432487f06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "520199f56f386b4b84e7b4d973abd4183664a89601ae2c5bab1d2ac9c7a32bfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end