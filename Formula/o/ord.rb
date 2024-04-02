class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.17.1.tar.gz"
  sha256 "08c47f23ea1d1b2b9027719b9df6703a160ec9448e34abed09c4482da1804073"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ff3af625ae6515af3e692143db4cafcb90914bbab7ee333cc064d039470da48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af4abf643ea007e793b8a2535de80e72e89557714c148c2b1a083468934a9319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e196d73775ffebd74128bfbe31af72226efa0d7c8cdabd1bec2d868948715fac"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a28ae0c7c3537c1d948db44fc81bbf0a4ed2e0e40a1c89d120e21f8e25028dd"
    sha256 cellar: :any_skip_relocation, ventura:        "1167907b603bcf534e16079d4884face5a07d81a581d9a3b76adb697406d9eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "adb513536f4b8403625a9c5531291b42265f50ff0c45d3101e242c1ca1a75d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb54c45fe8119f192b9d5217d91790d097cf2526b40e69c2aa7495d39f6cd35"
  end

  depends_on "pkg-config" => :build
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