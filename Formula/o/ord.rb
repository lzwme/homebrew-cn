class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.23.0.tar.gz"
  sha256 "1b802b532f2c31d90d41008af9c2c237f3bcc3855656a1dcb081d566c5f0e888"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f96479371dd73cb08c77d4d81cfa2dcae1aad1e7300953b64b062332f1f3be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3663691845b4517480b21df2a0d923795b08b8df1192a273203a5c0febff679b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7671158eb75a05ae49e9094b7da773fd0d2234982914908faef7ad480c55300"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d421e11d9accc2193a44ce21902299c20be2c4d9ba3b59b67c166a6a37f915d"
    sha256 cellar: :any_skip_relocation, ventura:       "ae1a26986ba03ad42885c9d2f0ffc985878f8eb832d3ed19e8b8576b30af3727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dcb48a8a809c543aa773c6fa5e407bd66e74028449fdf1458a1ecb08aa7fe3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe6bcdf964233997591274efd1812ff527f9f307b825d02a290b26be3a5c9a0e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}ord --version")
  end
end