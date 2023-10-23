class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.7.1.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.7.1.tar.gz"
  sha256 "7f0a929d775eef26a5a9f29fa3c013f3eefadbf6982cc086a7c75dddb9b4f429"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f8f69b7528397655cec90fbb26c905c0f458302d8fcc62737e16e53ef85d0fe1"
    sha256 arm64_ventura:  "6ec975c1c1f50c19e2d59ca183da7b6abe7d75445f939248b3aa6fd3e791a37b"
    sha256 arm64_monterey: "6eac90b943e9b6e1156a0e2d6f0bc2b9cac3f7e34a8d78a88de20a824a2185b9"
    sha256 sonoma:         "a59d2eeda8f39496f47312132780b160fd70806941b8acae6759b50afbdbdd55"
    sha256 ventura:        "08078b68ce17ff2e41dd013a6e3ad13b4c061fcb4b8816744c2b110362330c10"
    sha256 monterey:       "9d45eb8e77de3b14f94788466e5fccf3212901ad434f9cd53743755a90db30a0"
    sha256 x86_64_linux:   "0f06ac514054a4d11c10dbc03e56d92cb04ca415823ccf4ea3658c53a57b12af"
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