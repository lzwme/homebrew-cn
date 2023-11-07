class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.4/libadwaita-1.4.0.tar.xz"
  sha256 "e51a098a54d43568218fc48fcf52e80e36f469b3ce912d8ce9c308a37e9f47c2"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "af9d726140b9d513403fdc40d1a7fc79498b31d9aabec6f21fb49e2c0f512b27"
    sha256 arm64_ventura:  "d95e293f4ba64792c4d1dcd345787f7c9fc4374bddf1c5d39509fa42671e20d7"
    sha256 arm64_monterey: "1f25ce26257c45db9b84e208178015f71583ea6f5870b9b8804c54e4a9a69fde"
    sha256 sonoma:         "2839c84b74b81463361ac23f6dab3018b3d2bf3c0e9c5da24c761909253791a5"
    sha256 ventura:        "a1fc78b592393ecfe6d44e00e026668baaa92c554a37ac47f251356a82150ec5"
    sha256 monterey:       "56ef2911d9e94707539118e46bfda676e8d32df5ab16433c74ac95c1a4bc6701"
    sha256 x86_64_linux:   "b19c8e185da0f554f66df7959e4a2b3bdbe2f4826aaf980119a8747c5ad34d8d"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "appstream"
  depends_on "gtk4"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end