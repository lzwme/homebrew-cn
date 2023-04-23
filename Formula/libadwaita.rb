class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.3/libadwaita-1.3.2.tar.xz"
  sha256 "b38c91658b2d1fcb7eedf687858b0a54de39af6357661912b54271884c8e195e"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8e138b6f0eea447a7b04aeae7a32fdf58f8a9931e13a7731ba8a252074ed22ba"
    sha256 arm64_monterey: "51b6eed0f0e76473e3a0023dafebcff41d2304b6594b3e2d21ad8758cb3abc7f"
    sha256 arm64_big_sur:  "843af275f44922f5759c2b903da588d9d1c02a06903c5688562cfe83ec6eb2a9"
    sha256 ventura:        "8c78b787b728e228c66865898ea75a20b96a38a8e0b9428f08d6e5e5712ab2ea"
    sha256 monterey:       "9d1ee4b04fb659b3807c541e1a9b7591bc85337d4867a17726b10758c4e16eaa"
    sha256 big_sur:        "518e5e8780222d425f509a0af903ba2eb74fb133ce5c960ccb0f7eba1d5239c9"
    sha256 x86_64_linux:   "1a57057c5fa676cd39c43e05c1a23b3d1d411bbdc77724ad4f76b50a5d0eb5e7"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Remove when `jpeg-turbo` is no longer keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"

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