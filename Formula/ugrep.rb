class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.2.tar.gz"
  sha256 "37c207f5363fad2aea2d9793b9131fba5c2ba5d4360be575a6956c1aeba629c5"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "1b44cab833dfaea75cca63ca2e0b2851825e666eef2c6735d0184109019c2e24"
    sha256                               arm64_monterey: "68a275b52f2a7d10f44001708da2b187f09b17947ffc1c2e1f017c18acc991f3"
    sha256                               arm64_big_sur:  "7310619be69698252b97b8167923f82e267b5e674405a2e9554da522f94db873"
    sha256                               ventura:        "e69f063dafc1f65323932d0a0e8ad667b8bdefc6f74d6f669cc258d32fb4010c"
    sha256                               monterey:       "97038cbfa7b3c5becddbb090a4910cdfde2f7f175cbfe51b0c9da56e61f1647d"
    sha256                               big_sur:        "4a405fdae43dff34b388abb56d262dda3af3191a6d956fb7c2e01f7fcab2d69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa411bbeec4b0ab7d90af6c0a87147bf42929ec6c0ec6f115f42eb42d5b33b47"
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