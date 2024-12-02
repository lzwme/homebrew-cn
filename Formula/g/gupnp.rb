class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.7.tar.xz"
  sha256 "4a61d8a5a8a7270e60ce9cfe9661cc4fa326f045a65718d2eb8ff68afdbef805"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "8c18a95efa27ee27156418c2d9a99a8ce4206e06ff3a9ccc4206843f30d90f9a"
    sha256 cellar: :any, arm64_sonoma:  "9653aa3dddd82aaf175c4e543befdc12f21ce93f920fdbfcc7302fc5e23ca88c"
    sha256 cellar: :any, arm64_ventura: "e0bc178339fa428d98ec257e561165a2794e11144a591eb13a54d321e44168db"
    sha256 cellar: :any, sonoma:        "a83e95325c0fcdaaca81451aa20079dd11a348119555462eea2a62fa16e74afb"
    sha256 cellar: :any, ventura:       "9859c15edf1e93b81d7f17e524ddf6fd418701c83cdb0afa3da712f1ad4545ed"
    sha256               x86_64_linux:  "b8960e8b3d647fdd3c52312731e2e7f6934ae97807f76631036ad32a45272d5a"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "python@3.13"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    gnupnp_version = version.major_minor.to_s
    gssdp_version = Formula["gssdp"].version.major_minor.to_s

    system bin/"gupnp-binding-tool-#{gnupnp_version}", "--help"
    (testpath/"test.c").write <<~C
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    C

    libxml2 = if OS.mac?
      "-I#{MacOS.sdk_path}/usr/include/libxml2"
    else
      "-I#{Formula["libxml2"].include}/libxml2"
    end

    system ENV.cc, testpath/"test.c",
           "-I#{include}/gupnp-#{gnupnp_version}",
           "-L#{lib}",
           "-lgupnp-#{gnupnp_version}",
           "-I#{Formula["gssdp"].opt_include}/gssdp-#{gssdp_version}",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-#{gssdp_version}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-3.0",
           libxml2, "-o", testpath/"test"
    system "./test"
  end
end