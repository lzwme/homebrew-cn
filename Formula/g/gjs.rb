class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.78/gjs-1.78.3.tar.xz"
  sha256 "42d50364caa5d792c76734fe5bbcc4b9dbb48819da20a4060061e8b9526134a4"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "ecaf0d1dd59de7e02477d09c010a510efc6324e1f3832f9ca37bd3f8922bdf5b"
    sha256 arm64_ventura: "2d31defeaf4e98256e351ac342f5c06647524b600ea4bef175a3ca0a8339e5e4"
    sha256 sonoma:        "61f774b0e344e60c4bfc6b4a5c1dc73821a4fd61421a63a746d1bc7ce5022f7b"
    sha256 ventura:       "06c2a9b89fedd8de29f49b0465497c83beb3097064143a3ad56287f14481dca5"
    sha256 x86_64_linux:  "0eb46472c89a7b94745bfb105e3b69f90fe8eb1a35dede5f80937e358d13a539"
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