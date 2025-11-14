class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghfast.top/https://github.com/ordinals/ord/archive/refs/tags/0.24.0.tar.gz"
  sha256 "484f034fde3c329be7bb09478a46854ef397d5ed70141e1376028e34343a0388"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b28f86d92c29bfd8e43b0276b7ccff4ba9cd938bb48b1d6899781ae04eab40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d235a9ea77b6b213de0d750aca35e745b4e88e56537c79af371370e556b9e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae131e98fc0c49c81c340204f66461fcea082a6d2c5b54551dfb2e4dcf1ff349"
    sha256 cellar: :any_skip_relocation, sonoma:        "cde4a116f3409f1aa11f61afb66e7c18cb47006eabe16101de98bc996f76e473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9a7a66780ac3c2dd9e8a4c3f7535beb5f9b30bd08de6ddbd793a1b18d5eaf40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5718c7b49646d7c5beb0b706a5aee6f0916a716366ae8082c8916e51413cc21"
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