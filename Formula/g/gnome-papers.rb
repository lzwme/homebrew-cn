class GnomePapers < Formula
  desc "Document viewer for PDF and other document formats aimed at the GNOME desktop"
  homepage "https://apps.gnome.org/Papers/"
  url "https://download.gnome.org/sources/papers/49/papers-49.1.tar.xz"
  sha256 "4ab23a67897bddd6be2d6298210fff602cfec0f35688bc5bff270360b0784c29"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "49fa0178bf812aead907e30a95a607cbff002e804fc9e1410bd0fb47e0555edf"
    sha256 arm64_sequoia: "cdc8538c20006dac0caa965918e0f0137a9b6fff54bd762bf446fd1c4415c3d5"
    sha256 arm64_sonoma:  "ab451ed4da911a2fa68788442b9caedb5d0cfcacf34dbe24c4ba2eb91a82bd75"
    sha256 sonoma:        "8330aa12f7647fc2e95b995c53b5142de5c5c8b7ff013c2cbdd1afb7e2937d15"
    sha256 arm64_linux:   "f9c5c14a687120936e6508ace5935c01de21ce01468557d22b4ca8756f4397d3"
    sha256 x86_64_linux:  "fa6e239b5d32a4afe129233e611288cdb21f36c6e38b4e426787e3922c35a463"
  end

  depends_on "blueprint-compiler" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build # For blueprint-compiler
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exempi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libspelling"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    ENV["DESTDIR"] = "/"

    if OS.mac?
      # https://github.com/gettext-rs/gettext-rs/tree/master/gettext-sys#environment-variables
      ENV["GETTEXT_DIR"] = Formula["gettext"].prefix.to_s

      ENV.append_to_rustflags "--codegen link-args=-Wl,-rpath,#{rpath}"
    end

    args = %w[
      -Dshell=true
      -Dpreviewer=true
      -Dthumbnailer=true
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dtiff=enabled
      -Dtests=false
      -Ddocumentation=false
      -Duser_doc=false
      -Dintrospection=enabled
      -Dsysprof=disabled
      -Dkeyring=enabled
      -Dgtk_unix_print=enabled
      -Dspell_check=enabled
      -Dfile_tests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    resource "test-pdf" do
      url "https://gitlab.freedesktop.org/poppler/test/-/raw/1aca8a13eeaa37403f9330febcb4745affcfd139/tests/text.pdf"
      sha256 "9fac4cf9ac688f067ee38ddddcf9f237d4f6adf29601672e4ef1765c63997880"
    end

    resource("test-pdf").stage testpath
    (testpath/"test.c").write <<~C
      #include <glib.h>
      #define I_KNOW_THE_PAPERS_LIBS_ARE_UNSTABLE_AND_HAVE_TALKED_WITH_THE_AUTHORS
      #include <papers-document.h>
      #include <papers-view.h>

      int main(void) {
        g_autoptr(GFile) file = NULL;
        g_autoptr(PpsJob) job = NULL;
        g_autoptr(PpsDocument) document = NULL;
        g_autoptr(PpsPage) page = NULL;
        g_autofree gchar *uri = NULL;
        const gchar *file_path = "text.pdf";
        gint n_pages;
        gboolean has_backend;

        has_backend = pps_init();
        g_assert_true(has_backend);

        file = g_file_new_for_path(file_path);
        g_assert_nonnull(file);

        uri = g_file_get_uri(file);
        g_assert_nonnull(uri);

        job = pps_job_load_new();
        g_assert_nonnull(job);

        pps_job_load_set_uri(PPS_JOB_LOAD(job), uri);
        pps_job_run(job);

        document = pps_job_load_get_loaded_document(PPS_JOB_LOAD(job));
        g_assert_nonnull(document);

        n_pages = pps_document_get_n_pages(document);
        g_assert(n_pages == 1);

        page = pps_document_get_page(document, 0);
        g_assert_nonnull(page);

        pps_shutdown();

        return 0;
      }
    C
    pkg_config_flags = shell_output("pkg-config --cflags --libs papers-document-4.0 papers-view-4.0").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags
    system "./a.out"
    assert_match version.to_s, shell_output("#{bin}/papers --version")
  end
end