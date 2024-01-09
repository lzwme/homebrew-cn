class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.78/gjs-1.78.2.tar.xz"
  sha256 "6a2abeb6bb7b49dd20a2e86475a56c1d992ad271a0991e58b1431ad1d4997fd5"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "daf8eb10afaee6a4a6db765031620903fc4caba090a422ddbd71079aeebf72c6"
    sha256 arm64_ventura: "b85ac925c02cce8b0f9ab924dfd3a3a8a9c69a18048dc8e9677f0decad0ed206"
    sha256 sonoma:        "91e234910f21cc669c059364d0b02d769d2ed380a4c438e6c3b69a1680745d66"
    sha256 ventura:       "9322380c69be5fd56236d68e3ddfe22f3111c7b9ce2716845a205bb4f7d77b3d"
    sha256 x86_64_linux:  "a5a6992d4f815876652b49975abdaf6ed57728e977169d770542f49bb35fdf2f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "readline"
  depends_on "spidermonkey"

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.js").write <<~EOS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    EOS
    system bin/"gjs", "test.js"
  end
end