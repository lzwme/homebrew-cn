class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.net/"
  url "https://ghfast.top/https://github.com/dharple/detox/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "409c25875da37137a390d29a65d0cadcf99c4f6fe524fdb76bc1fb7e987ab799"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "bb8e9362999ad6334ece927cb05875ffd92f46d7127fc7b354ba66d73716be56"
    sha256 arm64_sonoma:  "aae15dfee10976d473d400b0830c415bd154fa946cf6e36b03a4d781d0923d12"
    sha256 arm64_ventura: "eac0f4171f62ca9f70e540d45fa3019e06edac2f0f847f4f714f66ac550ab8b2"
    sha256 sonoma:        "613dc7c33956fab7088dedec1ee060ad8f6e0bc18c5aa18ea3988f9da007b884"
    sha256 ventura:       "da7ed61574f4ff64d63d63c6806493a33e5bf1e8dae4c879074d37b64f98c7fc"
    sha256 arm64_linux:   "148017084514876dd611f5a51bb8ce981167c2cf0dc8cc1cbe8753cd1afd04a6"
    sha256 x86_64_linux:  "d0601f06bcd9d68f4ab6b12d17497e8d2ffc7fbe66868db5d6da6e2e7be1cba4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end