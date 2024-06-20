class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.41.tar.xz"
  sha256 "3ad392af91115b7740f7b50d228cc1c5fc13afc1da7f16cb0213917a37f71bda"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8564b7e32eb44d0f06d621181a770cdf4a3e20a104bcb603b26e27b93cf3f2de"
    sha256 cellar: :any,                 arm64_ventura:  "a59219d57c8ba7e90fc29d8f48f36fb6639ed0b86e6c2ae156e0d69fc854304e"
    sha256 cellar: :any,                 arm64_monterey: "f473ad97775ebbc54988b87abb07d9ff553d77a781642a221ffd57b22176ded8"
    sha256 cellar: :any,                 sonoma:         "25add8dfb26997d70c8c5078cc4052b957b7a4c9ec4b16e34a83ed5f8f60338d"
    sha256 cellar: :any,                 ventura:        "6c1fe3aec9f51ae802a59fa5122712732ae854cbcb1dc3317c11a65d2ecee964"
    sha256 cellar: :any,                 monterey:       "4a2901b93c934a895421a017982da0885e7b1584a2060fbf945609757a5b1495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abee7df413e69bc6e6a943d8456db2ca2802506a3b7f19d4f355d88763fb28a3"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "icu4c"
  depends_on "libgcrypt"
  depends_on "libxml2"

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    libxml2 = Formula["libxml2"]
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{libxml2.opt_prefix}"
    system "make"
    system "make", "install"
    inreplace [bin/"xslt-config", lib/"xsltConf.sh"], libxml2.prefix.realpath, libxml2.opt_prefix
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~EOS
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    EOS
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end