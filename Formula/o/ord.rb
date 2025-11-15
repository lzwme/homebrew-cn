class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghfast.top/https://github.com/ordinals/ord/archive/refs/tags/0.24.1.tar.gz"
  sha256 "121ef8bcdae6e16f5104f804cf9673cf99780f0e0ae957d9a34ba8e9e9c615d9"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b15e6d1269a7377de418e786ce193f9dbbdb2fc37c462d553d40c6cc907b954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "242c56055b39247775662f58f6039f917a00f7aca10a498a35df6ce92cab9b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8537d650b5f6d20a09872fb5c6d5863a5fbbccd3e6b09ee2b2ef94ee461d7046"
    sha256 cellar: :any_skip_relocation, sonoma:        "e73e675581dbed46ecf5078eac284b7df3673e12695f031889e6d334e3ce556a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c111b2e23bf5ba5814828c81717c8a697de882b978b7cbb5bc2c3f257f9f909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6d12ebfad63ef618cc7a51eab426393225d49d97048097063d775c1cb12acf"
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
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end