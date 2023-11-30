class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.2.tar.xz"
  sha256 "b4e993bd827e4ceb6a770b1b5e8950fce3be9c8b2b0cbeb22fdf992808dd2139"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "c3073d875233e0bfb03722e4d5e815b549a8a8eb14e5262a7e6efa342e463895"
    sha256 arm64_ventura:  "1c27e15fc2e539e47a8fe8c0091d90b8098e60a4bd2fcbc9022e041450859da1"
    sha256 arm64_monterey: "4a1a9c85a603dd2f18dc24a0206aaa2912e8a7103cee2b14015e50349512694d"
    sha256 sonoma:         "df2bb7f2f847a8df3a9d3ab123b91406bab7c3c1b758c2852a54468ff72edfff"
    sha256 ventura:        "1ebf779b92af0dfb394def7c5923a9a64f20772e2ad7dbead93cfce181a20ca6"
    sha256 monterey:       "5bce087e7c18df26706677e01c7beb7b33da2fb657b2baf012be9e1b7517e4f9"
    sha256 x86_64_linux:   "58ff08f8cc41b9d4e02463836d5fa162be9cb810bb57c4a3c13319d85dfa30e7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gtk-mac-integration"

    patch :DATA
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-introspection=yes",
                          "--enable-vala=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end

__END__
diff --git a/gspell/Makefile.am b/gspell/Makefile.am
index 076a9fd..6c67184 100644
--- a/gspell/Makefile.am
+++ b/gspell/Makefile.am
@@ -91,6 +91,7 @@ nodist_libgspell_core_la_SOURCES = \
	$(BUILT_SOURCES)

 libgspell_core_la_LIBADD =	\
+	$(GTK_MAC_LIBS) \
	$(CODE_COVERAGE_LIBS)

 libgspell_core_la_CFLAGS =	\
@@ -155,6 +156,12 @@ gspell_private_headers += \
 gspell_private_c_files += \
	gspell-osx.c

+libgspell_core_la_CFLAGS += \
+	-xobjective-c
+
+libgspell_core_la_LDFLAGS += \
+	-framework Cocoa
+
 endif # OS_OSX

 if HAVE_INTROSPECTION