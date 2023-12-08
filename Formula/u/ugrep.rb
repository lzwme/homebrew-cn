class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "e7ba12da8c1ac4b9a1752e11aecc90067289b149e47d214f5befb0f63a1a7728"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "2bbec35ecbf9a93a67bac02827a830002347c11d10f94655018e0cf662eab90c"
    sha256                               arm64_ventura:  "11f39404427b71ad7c73f7143a6364dcd89ff1626fe8bc110abb8bacbdc93952"
    sha256                               arm64_monterey: "888cf0288cd12511c752c990dee257983ba86a740001886b5c848beaabc31e10"
    sha256                               sonoma:         "69d135f64be9fed2d17a13a5d0ca07733b252135dc5f9c126d5bfd56afc66277"
    sha256                               ventura:        "cf5d1dc4f2d43624382bea088f72f9596ad99db6544ccd16b1a5e67d09bfd06e"
    sha256                               monterey:       "be01766d64a13d4d7032d933f24fd94299120903762bdc1d409279f2590d5806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223da4309afffba93385a0b142f5cd6f07962efabc1e113b219fca7a0e1b7b97"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end