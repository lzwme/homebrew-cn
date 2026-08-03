class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghfast.top/https://github.com/ordinals/ord/archive/refs/tags/0.28.0.tar.gz"
  sha256 "c14626db1fac36fbe93b33bde0d6cd5ff6d637944f6000ba3222d3d9661d6ce8"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bc12ac8fde84eaa44e8534ab55e39bfdec6776d276875a9e9ad26cecc54f220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf2c68d05899836b06a4300ce607f12ff52a6df96db4b808d60b71ee1652c3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d359ea05935261295b0f4540cce1721119f6bb71017d50ff3de3d2cc825e1eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "64af4252b16a3f5a2526af9fb365478e2042b0ed2414b74d0b808b88a7cec4a0"
    sha256 cellar: :any,                 arm64_linux:   "935cb29f7cb6955109a9168cfa56565ba0cb39162736db75ef7639511d0e14c7"
    sha256 cellar: :any,                 x86_64_linux:  "c2a3731d8628bf4a4c560c77ecd422624bade5ef5501319457c76c1950f1929a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end