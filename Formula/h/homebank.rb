class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.10.1.tar.gz"
  sha256 "67512d3188ea45f92a6f9326e829c142af5ad509306702f3b0457a1ab611d42a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6675d91078291a5d38e722fdcb85c7613538ff1d1ab010e0159b84ec5080da3d"
    sha256 arm64_sequoia: "64419ff08f0dceb87bb27259e70191807bd5c4980f2dc5487864aa7b2de321b4"
    sha256 arm64_sonoma:  "da8d22e8ea33a33ab20d7b938ea42d899b3e04a6d0211d93669e8e43dcf14334"
    sha256 sonoma:        "1ec095eb3de4ae80fd706907311fd76af450cd337228a4a619eecfd6ffedb4bf"
    sha256 arm64_linux:   "dd1316f6e064335d3c0cfad23d5a9627d29ad7b714e8435e08b8b9ca7e777af0"
    sha256 x86_64_linux:  "411a0295c13caf4e07e16c4744b650b3d226c1359d613f84b9f4f3a2b1702f80"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--with-ofx", *std_configure_args
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end