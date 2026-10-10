class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "99d51d8171e4bb6741da287d15011f676d567d9d20db4593e01965c044d6a83b"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f94c329fbcaecd304f2d61a24efe685ba63db0815f424f1c80bb75dc9bca9fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a65c3e5e03697f045889ae1ddb40c36ff93396b547f7e7767c62574e82e4eb38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f21680a0293375c2107b722a1650d2dd8db117dbacba6c0f640b5cd23920625"
    sha256 cellar: :any,                 arm64_linux:       "65a639927ccfe38b32142bb1356b9c4eab6edc63c28b2abe3f3084c0811858a0"
    sha256 cellar: :any,                 x86_64_linux:      "0dd5a58a9b5833c0ea04b440f13c0065cbb9723f5857cc99558de786a04bf406"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end