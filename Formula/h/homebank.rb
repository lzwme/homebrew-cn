class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.7.2.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.7.2.tar.gz"
  sha256 "331d7ef88d90f3f34ca6610f7f18e89e935443b18b091a87d9b94bd7556399ef"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "201d084e6b53ff3f7f6ed488e70568455010e6ebdc89cccaad0f7e340a43c85d"
    sha256 arm64_ventura:  "ef47fe7cc1a32610dc9108c24e73a01540e156f209e17dbdb4568da9d4598c6c"
    sha256 arm64_monterey: "ae51fffbbdfe5cf7a113caa1c5322f2c8393748548e113da5a098a509fc543dd"
    sha256 sonoma:         "482e5abd7188b41b3024fa1aae498ef9728fab054ad331249319bd2412f23ce2"
    sha256 ventura:        "8ef6a140c760a33611597060e10c62d99c3e8276469153598b933d9b65f87cf6"
    sha256 monterey:       "01f552b5d2454e5e2e6c7edb652b3073f1d39e6016dffc0533a6c58a87614d66"
    sha256 x86_64_linux:   "a5343c6d6e0df147fe41640dd546f5f2be46ef437c6e8f653eb1d1cc388f02a4"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  uses_from_macos "perl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end