class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.17.0.tar.gz"
  sha256 "57883d3916ef8325252359af00c66352758cf9044bdfad102d234bf98899838a"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23196a0339a557a240f645632791bcd9e36bcb909532261fe39615a6abfb0d79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bb92660bc41a1d135cae32dd2c57e5470991560db2953656f0cb65520ef1bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e3a41b358e8f732535630fee3f1c455ac6e38e7790939989781e27c3c0b3b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "be1861b51b0864c1afd22c9a8a2c02e576e8f00c9d43e4e950af631568384f76"
    sha256 cellar: :any_skip_relocation, ventura:        "50eb364a00674e7b6833718baa8606167caafa92f67a948df59b2d819f01815e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a245138eb1102cc9724b2b951e9a9f69d7d4c02e292401349b46c919e3f6954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79ac5bdafec1ce622bc636f5ff3d868b92a60a8a0ea7905a939cc046fc79873"
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