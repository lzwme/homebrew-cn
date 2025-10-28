class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://ghfast.top/https://github.com/Qalculate/qalculate-gtk/releases/download/v5.8.1/qalculate-gtk-5.8.1.tar.gz"
  sha256 "6e4ae008f10a46a6bd91adc68dacca33fabaee10cbd96481a367fee588d5f4f6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "ceab122f3b2c52ad84da986bd7aa44997903157a1029d56e277000ff312fc5a4"
    sha256 arm64_sequoia: "355cc323f0b5669c68715d81d11945d20c7ff78b63fb0216c8bf91c7090fbcf2"
    sha256 arm64_sonoma:  "33282ef361956244942d9e5673f623677a19e85949d7b84d6843e868160a1153"
    sha256 sonoma:        "ac44faff648d663334a3043868b23113ad13dd5bf79964a1ce273086e0c2b5af"
    sha256 arm64_linux:   "f6776d96b9a4ff7ae7e8594cac309d79b3288aac77d50e3a525d8f21e7120579"
    sha256 x86_64_linux:  "1ede38321cc3e396957a070c0a196a6dd47db91d357ece361f71aba33af6b87b"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end