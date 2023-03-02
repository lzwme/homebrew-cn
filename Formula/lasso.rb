class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.0.tar.gz"
  sha256 "ffcbd5851d98586c7e1caf43bad66164211a3b61d12bf860a0598448ff9f2b38"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "232452155fca74c8c35ef5a5d0cf4e6f87b4748f53a4f68be375b50390a22852"
    sha256 cellar: :any,                 arm64_monterey: "1234da53fe66054f3b22628b155ddad4b701e039aef6f648d4233ed0fbba0177"
    sha256 cellar: :any,                 arm64_big_sur:  "41c8f358f24567d8e813a30362c67e14a66ae7534746aaad23f5b36eaa1c35e6"
    sha256 cellar: :any,                 ventura:        "74fb574697df10b93d8708cc38d427a24f537cce5c95258c6cf1b6690c505817"
    sha256 cellar: :any,                 monterey:       "24604ecf58d01e58194a75e57c69237ecf85cceaf544b314cd4a59d4fd5e4f77"
    sha256 cellar: :any,                 big_sur:        "8a395f2aa86ef1a5f22f23b3bc4b7fbca51e108b0c3afbea149e731932d59033"
    sha256 cellar: :any,                 catalina:       "149148a36bada2068998128bdccb2887149cb8bbf8da23398546f734a1a8e03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5818abda0bcd05f97c6bc342142623a13e70f3b0ae4fe036703b3d2e944f354"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "six" => :build # macOS Python has `six` installed.
  end

  def install
    ENV["PYTHON"] = "python3"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end