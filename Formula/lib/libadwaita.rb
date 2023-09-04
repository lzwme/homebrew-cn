class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.3/libadwaita-1.3.5.tar.xz"
  sha256 "faa3ff0f36db18ab4942f4904a295293ccb144755b9bb85131393f201926b586"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6d85d0d5c2d4d48934730d04b1d71fcdaaaa4d5340121de7331be6a454df411a"
    sha256 arm64_monterey: "8f6bfd36aa92234f34c453fbb9d8556470b18c0955610551c4d1a3e1a1fd46fe"
    sha256 arm64_big_sur:  "63ce30ff4af57ce0a74b87470b1924407af75a14b94cc9c81740a62b7b46e9d9"
    sha256 ventura:        "a65f238ab3becb3d69862e92ded83bc75255ce9291e58a2622497798a0537340"
    sha256 monterey:       "eb4efa96500402a29400b4ed1a7bf6813904bce971e5637052d88efdcc37e44d"
    sha256 big_sur:        "0c21c762f5e5e0a84d8d749cc6214ee9aae2ff566e4dfd4abf5b75923553ae83"
    sha256 x86_64_linux:   "9c9ed668d719bab47cc21c920d3214de8c81b9447232ba8f0bce968053a41b05"
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