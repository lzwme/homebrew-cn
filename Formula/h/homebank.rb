class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.7.2.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.7.2.tar.gz"
  sha256 "331d7ef88d90f3f34ca6610f7f18e89e935443b18b091a87d9b94bd7556399ef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "532262b58f63d8c0c4bf8175244475c5399555a3a2edb0cb0de31632f67bcb33"
    sha256 arm64_ventura:  "d58d64a807f8a4b385e7817b74e20536b739357f96c23171b53a3d9eac3330e8"
    sha256 arm64_monterey: "9f3ceeb52e70b12a0153f89621f7f010546155b8d4d3ccf13b41cfa5ac7934fe"
    sha256 sonoma:         "3a27bc3fd7df7edd97283ef1f77acf166b73b817ed18dbf763e8a4a900a9eb41"
    sha256 ventura:        "ec499a4a9436b1be392d6911bdde830ed29c0bdc15a6b67904f01dce67666614"
    sha256 monterey:       "9e7ba6f4f71b579464b99dfbfd3ac0e674b456642ce8b8c7f9774b1323b72495"
    sha256 x86_64_linux:   "9832a56ddd60b8a14fef16d5b21f1b53d1e910c3bc387d6819b4443732a9eb18"
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