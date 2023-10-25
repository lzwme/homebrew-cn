class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    sha256 arm64_sonoma:   "f0b8bfbb01993aff995701de379d3b5e6580cae861052972a744720dbb9cf526"
    sha256 arm64_ventura:  "14041c9e8d1d5a87fa0543fe021f4b188b876c35c62ffc071b0bf65f1a30fcd9"
    sha256 arm64_monterey: "9d96d60f458cb1c9e9b04cddb224ce280d7284391fc37163cc46d8db7dbde690"
    sha256 sonoma:         "6763bbffcec0d1da9ba419287a0f776b6dd5946d5e2a8b5ace83cb87a6b04e30"
    sha256 ventura:        "b4794e4b8df053b5e4d5512be47294528903db669891dc9a23a73205ad94daea"
    sha256 monterey:       "709587da04117f21038b23b304c1cbcf9a1e7d6efd1ad92e394916692311357e"
    sha256 x86_64_linux:   "9d4aff672568ae10160182dbde2c04f4a22283e6f871c5907004c6170c69fe41"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "flac"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "taglib"
  depends_on "wavpack"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # disable gtk-update-icon-cache
  patch :DATA

  def install
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages("python3")
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
    ENV.append "LDFLAGS", "-lz"

    system "./configure", *std_configure_args, "--disable-schemas-compile"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Disable test on Linux because it fails with:
    # Gtk-WARNING **: 18:38:23.471: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/easytag", "--version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 9dbde5f..4ffe52e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -3960,8 +3960,6 @@ data/org.gnome.EasyTAG.gschema.valid: data/.dstamp
 @ENABLE_MAN_TRUE@		--path $(builddir)/doc --output $(builddir)/doc/ \
 @ENABLE_MAN_TRUE@		http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<

-install-data-hook: install-update-icon-cache
-uninstall-hook: uninstall-update-icon-cache

 install-update-icon-cache:
	$(AM_V_at)$(POST_INSTALL)