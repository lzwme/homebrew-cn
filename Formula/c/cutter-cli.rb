class CutterCli < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://github.com/clear-code/cutter"
  url "https://ghfast.top/https://github.com/clear-code/cutter/archive/refs/tags/1.2.8.tar.gz"
  sha256 "af29d3d61076fc03313fc1b8da76aa8b884edf683e684898be5d33ba8440df14"
  license "LGPL-3.0-or-later"
  head "https://github.com/clear-code/cutter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "50d803be696157000e10e3227f4ad22d3e1ed5917ce8f2d7eb51b3fbdaffcebf"
    sha256 arm64_sequoia: "627cc5e5c31aec18475add356162f262601856eb5a050548091839520d66fd9c"
    sha256 arm64_sonoma:  "ae94f44c2d807ce69bcaa8af9266ecdc5ae3c552ab1ea675dad959793ea60da8"
    sha256 sonoma:        "d040c17775b47a4ead2759cbc45432337bafe6f02f9b51a21f23b62e31ac8848"
    sha256 arm64_linux:   "b01b73b45d595f7fe956df3f1d65173968df35ea24a1852ed32f5b1792fcdfc4"
    sha256 x86_64_linux:  "37fff430a510aa2de9602f8e8a0835f8b2ed01bab112154b30c3fac1c55d98ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end