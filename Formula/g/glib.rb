class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https:developer.gnome.orgglib"
  url "https:download.gnome.orgsourcesglib2.80glib-2.80.3.tar.xz"
  sha256 "3947a0eaddd0f3613d0230bb246d0c69e46142c19022f5c4b1b2e3cba236d417"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "1658d3a6f68cbd4d92652971f9c8fcbb485a792bb4ade14159949e32891e930f"
    sha256 arm64_ventura:  "7da35cf5176cfc050731a54ce2ec43035c1fd44b10a31308d4430dc825cc36f4"
    sha256 arm64_monterey: "188c7c13365db163ecd4210ae60e315f0f84a16901c2126df0687c485ddda8d6"
    sha256 sonoma:         "00fd287ab762d8e4b7f458a20d7a5a8924b5a185df6a070a9139f21ccd685b29"
    sha256 ventura:        "6c1018e3de9ee27e0da413a56afaf42bc75eb148a846bfbbe86fe0cde6f29a07"
    sha256 monterey:       "b6761564a1021728437898d4b91c5468cf237ec972a06abc296082ca5c32acd1"
    sha256 x86_64_linux:   "0e5f553733e0bf87c88c0c98cbcb5dc4de4aa41ced5b78e345924362fbaf62a4"
  end

  depends_on "bison" => :build # for gobject-introspection
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build # for gobject-introspection
  depends_on "pcre2"
  depends_on "python@3.12"

  uses_from_macos "flex" => :build # for gobject-introspection
  uses_from_macos "libffi", since: :catalina

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "dbus"
    depends_on "util-linux"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bingdbus-codegen", "binglib-genmarshal", "binglib-mkenums", "bingtester-report"
  link_overwrite "shareglib-2.0codegen", "shareglib-2.0gdb"
  # These used to live in `gobject-introspection`
  link_overwrite "libgirepository-1.0GLib-2.0.typelib", "libgirepository-1.0GModule-2.0.typelib",
                 "libgirepository-1.0GObject-2.0.typelib", "libgirepository-1.0Gio-2.0.typelib"
  link_overwrite "sharegir-1.0GLib-2.0.gir", "sharegir-1.0GModule-2.0.gir",
                 "sharegir-1.0GObject-2.0.gir", "sharegir-1.0Gio-2.0.gir"

  resource "gobject-introspection" do
    url "https:download.gnome.orgsourcesgobject-introspection1.80gobject-introspection-1.80.1.tar.xz"
    sha256 "a1df7c424e15bda1ab639c00e9051b9adf5cea1a9e512f8a603b53cd199bc6d8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches43467fd8dfc0e8954892ecc08fab131242dca025glibhardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gioxdgmimexdgmime.c glibgutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "giomeson.build", "install_emptydir(glib_giomodulesdir)", ""

    # We don't use a venv as virtualenv_create runs `ENV.refurbish_args`. This causes `gint64`
    # to be detected as `long` rather than `long long` on macOS which mismatches with `int64_t`.
    # Although documented as valid (https:docs.gtk.orgglibtypes.html#gint64), it can cause
    # ABI breakage if type changes between releases (e.g. seen in `glibmm@2.66`) and it breaks
    # assumptions made by some dependents. Also, GNOME prefers equivalence of types but cannot
    # require it due to ABI impact - https:gitlab.gnome.orgGNOMEglib-merge_requests2841
    resource("packaging").stage do
      system "python3.12", "-m", "pip", "install", "--target", share"glib-2.0",
                                                   *std_pip_args(prefix: false, build_isolation: true), "."
    end
    ENV.prepend_path "PYTHONPATH", share"glib-2.0"

    # Disable dtrace; see https:trac.macports.orgticket30413
    # and https:gitlab.gnome.orgGNOMEglib-issues653
    args = %W[
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}libgiomodules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}run
      -Dtests=false
    ]

    # Stage build in order to deal with circular dependency as `gobject-introspection`
    # is needed to generate `glib` introspection data used by dependents; however,
    # `glib` is a dependency of `gobject-introspection`.
    # Ref: https:discourse.gnome.orgtdealing-with-glib-and-gobject-introspection-circular-dependency18701
    staging_dir = buildpath"staging"
    staging_meson_args = std_meson_args.map { |s| s.sub prefix, staging_dir }
    system "meson", "setup", "build_staging", "-Dintrospection=disabled", *args, *staging_meson_args
    system "meson", "compile", "-C", "build_staging", "--verbose"
    system "meson", "install", "-C", "build_staging"
    ENV.append_path "PKG_CONFIG_PATH", staging_dir"libpkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", staging_dir"lib" if OS.linux?
    resource("gobject-introspection").stage do
      system "meson", "setup", "build", "-Dcairo=disabled", "-Ddoctool=disabled", *staging_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
    ENV.append_path "PATH", staging_dir"bin"

    system "meson", "setup", "build", "--default-library=both", "-Dintrospection=enabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib"pkgconfiggio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}libgiomodules",
              "giomoduledir=${libdir}giomodules"

    (buildpath"giocompletion.gitignore").unlink
    bash_completion.install (buildpath"giocompletion").children
    rewrite_shebang detected_python_shebang, *bin.children
    return unless OS.mac?

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"]
    inreplace lib"pkgconfigglib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext.opt_lib} -lintl"
      s.gsub! "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include",
              "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include -I#{gettext.opt_include}"
    end
    return if MacOS.version >= :catalina

    # `pkg-config --print-requires-private gobject-2.0` includes libffi,
    # but that package is keg-only so it needs to look for the pkgconfig file
    # in libffi's opt path.
    inreplace lib"pkgconfiggobject-2.0.pc",
              "Requires.private: libffi",
              "Requires.private: #{Formula["libffi"].opt_lib}pkgconfiglibffi.pc"
  end

  def post_install
    (HOMEBREW_PREFIX"libgiomodules").mkpath
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}glib-2.0",
                   "-I#{lib}glib-2.0include", "-L#{lib}", "-lglib-2.0"
    system ".test"

    assert_match "This file is generated by glib-mkenum", shell_output("#{bin}glib-mkenums")

    (testpath"net.Corp.MyApp.Frobber.xml").write <<~EOS
      <node>
        <interface name="net.Corp.MyApp.Frobber">
          <method name="HelloWorld">
            <arg name="greeting" direction="in" type="s">
            <arg name="response" direction="out" type="s">
          <method>

          <signal name="Notification">
            <arg name="icon_blob" type="ay">
            <arg name="height" type="i">
            <arg name="messages" type="as">
          <signal>

          <property name="Verbose" type="b" access="readwrite">
        <interface>
      <node>
    EOS

    system bin"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_predicate testpath"myapp-generated.c", :exist?
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath"myapp-generated.h").read

    # Keep (u)int64_t and g(u)int64 aligned. See install comment for details
    (testpath"typecheck.cpp").write <<~EOS
      #include <cstdint>
      #include <type_traits>
      #include <glib.h>

      int main()
      {
        static_assert(std::is_same<int64_t, gint64>::value == true, "gint64 should match int64_t");
        static_assert(std::is_same<uint64_t, guint64>::value == true, "guint64 should match uint64_t");
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "typecheck", "typecheck.cpp", "-I#{include}glib-2.0", "-I#{lib}glib-2.0include"
  end
end