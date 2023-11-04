class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.56.tar.xz"
  sha256 "b8640a2fee0c0a57784b2a5b92944a2932c789db1039ddf5a269ad634796e7e2"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_sonoma:   "5a613d5b56c610af0735ced2c4084a7fadaf1977afb1156d14273e28d80e5c53"
    sha256 arm64_ventura:  "b381103634690f60bec710b4eb8fb0bd6151a7db4c800564b3460a9498bda2b7"
    sha256 arm64_monterey: "132313c560eed410b17a3092d8a4198ac7783baada45bc4c85d5b019ff0d2291"
    sha256 sonoma:         "308b048eb8fc34007783d4fcb185b42338a73663c2a90f459ddd600606014e40"
    sha256 ventura:        "da5ca181943406c89273fde578694db085e1d507459875d544bea1e74c0fae71"
    sha256 monterey:       "c9f9f7fbcbdc52a0de548e7990931b52c5bafb9cfc335079e1e11ed93b4d50cb"
    sha256 x86_64_linux:   "e374e7fec0b9b5ec3deda040be56cde513914cbbb9517d3ea6a55d2ac9e3e022"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/goffice.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <goffice/goffice.h>
      int main()
      {
          void
          libgoffice_init (void);
          void
          libgoffice_shutdown (void);
          return 0;
      }
    EOS
    libxml2 = if OS.mac?
      "#{MacOS.sdk_path}/usr/include/libxml2"
    else
      Formula["libxml2"].opt_include/"libxml2"
    end
    system ENV.cc, "-I#{include}/libgoffice-0.10",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["libgsf"].opt_include}/libgsf-1",
           "-I#{libxml2}",
           "-I#{Formula["gtk+3"].opt_include}/gtk-3.0",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdk-pixbuf"].opt_include}/gdk-pixbuf-2.0",
           "-I#{Formula["atk"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end