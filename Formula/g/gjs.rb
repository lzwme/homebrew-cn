class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.78/gjs-1.78.0.tar.xz"
  sha256 "fbaa20e0917668830800f92951688f9fc08f01296affd5cdb4b35f750be27dc9"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "1a302b189df064777977bffddbd909ae6b2fc8c465466a076c4a9361a325320b"
    sha256 arm64_ventura: "ac9ede73a1296c48476b811ff1bbb3d9eff7a97b5246947ffbb97985e9d658d2"
    sha256 sonoma:        "4dd28ee54e5191e293fb94211482939ef63912065d310ecffc78b9fb073e5265"
    sha256 ventura:       "ad84e779ebe71ff47589e29ec7fccab7565db267fccce639977442fff3df9e09"
    sha256 x86_64_linux:  "d7eadb2734db907c7984a2e070733d9bc9a4dec79b38d12cb40476aa563c39d6"
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

    args = std_meson_args + %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    system "#{bin}/gjs", "test.js"
  end
end