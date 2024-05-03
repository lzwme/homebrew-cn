class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.18.4.tar.gz"
  sha256 "fff991609a16392162d98907bdc62121574fc2ccfaf61becebb19ad5ce4f4b8d"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2037721b7bcd43cf37d99b80058ab1a54dcca8dbcf02e24c127e61e5ba9a3643"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a5de0e6565b8116258e89aebc5a017921f204aa8280fe7809e8a79f4d859ce1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cdbb35c2b827b7fe6b9cb1ff3610cd6156cda511a0fadcb06b0927b7bd50be"
    sha256 cellar: :any_skip_relocation, sonoma:         "eadeae02dd636c4c2e6e1b851a16beeb6ac8f5c4987a951e5db5b79759c08792"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f37380e6a87fc679be9d16aab9f31718ffe831d72e7356d757f3f50a35e298"
    sha256 cellar: :any_skip_relocation, monterey:       "58de416deb191ae29f15480edd21a41fd52007ed0f3ba2b85bbe1bf9c23bf274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c26ca90dcca5243eb24082fa65f140bc868ef9a6bc2bb872100b602c0271624"
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