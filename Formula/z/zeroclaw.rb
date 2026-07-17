class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9dd537164012bd122cdc4837b09a20146ea3311aa493cd642a870778871f0d27"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a9e0062d0021915442673e314d03374495a8adbc3765c6c7dc50c2af79dccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2c16ac74a9cf9d7b99159ffdd916e14fc39f8b4d0ee19c01159557027ee197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93fd9e391202177d10c8ee71230e5dea61ffb5c1d47812b2dfa405d7abdd8ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "33439a23a16befddcfaddfa809134e764f5499f879147d2200d1ac20fbaa5446"
    sha256 cellar: :any,                 arm64_linux:   "257670e85928a0ea46cf71dccc15f310b6dbe432cb159d31c1f7e25710d22489"
    sha256 cellar: :any,                 x86_64_linux:  "7a6775fa1d105b09a35e5018ae629c9544a4594f294aad48cb5e1af4e859a1ef"
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