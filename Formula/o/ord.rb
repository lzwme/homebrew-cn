class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.18.2.tar.gz"
  sha256 "c338fed9766fff8300832c46cc91ce7a38c21f96103010a3260c1933e9ecbfb8"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53ae950ebcf0edb3796518a9305d4adbb5a75a1580fabf3fe7920fa178e9da8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "841dc1bdfa9243d1e062193610ffe42b806ac9633195f5087de5323da8d78c8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfb11ad5861e44391a126aff7e81ad9962d4bb92f63ab98bbb1f92464039cc2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4022ba864b9b4ab48a00c087a97643dcdb4762bb32c9387d611845a195a93b8"
    sha256 cellar: :any_skip_relocation, ventura:        "668f88a7b9c7bd21cc4c284f1d7ed81975fd8f9ed8f400ffc4e924277aaeb5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "dc0d892add0504f7ce7062a154e4060b962c62f831cf235a5f934784e6fadc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea5ca787e36ed1cedb643f728b4d9e7c5b516fa51e1fab6c0228eacd0385fec"
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