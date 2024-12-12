class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https:docs.gtk.orgglib"
  url "https:download.gnome.orgsourcesglib2.82glib-2.82.3.tar.xz"
  sha256 "5d669bd01ad23b8ef8082c58a0d205f4007a9b9c42b0a69fe7aeb17bbee58ce4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "316bf128dc0089ecb3af9beb92029a20b8b43095d73442d15f100ae8204b32ef"
    sha256 arm64_sonoma:  "197af71eb767ac3e88253ef239be61d5abc5eb12c3f1840b573603ba052e26e5"
    sha256 arm64_ventura: "d4d1205380a9eda7f5a53abbe799a44435545adca7d2069d3873a240018d6acf"
    sha256 sonoma:        "abf002cd6b4829080bf4080a3ea3f4f705cf6b4fc2480e05d644923d2f57ea8a"
    sha256 ventura:       "a5e88905b4c9e1db5c319235b7799972fd0fad9bda6f0c3dafe405e7c1d758e9"
    sha256 x86_64_linux:  "1b6481391c3aebee219a116f88390a0d0741392a971527c911fe7ba4002e42f3"
  end

  depends_on "bison" => :build # for gobject-introspection
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build # for gobject-introspection
  depends_on "pcre2"
  depends_on "python-packaging"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build # for gobject-introspection
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

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
    url "https:download.gnome.orgsourcesgobject-introspection1.82gobject-introspection-1.82.0.tar.xz"
    sha256 "0f5a4c1908424bf26bc41e9361168c363685080fbdb87a196c891c8401ca2f09"
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches43467fd8dfc0e8954892ecc08fab131242dca025glibhardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    python = "python3.13"
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "giomeson.build", "install_emptydir(glib_giomodulesdir)", ""

    python_packaging_site_packages = Formula["python-packaging"].opt_prefixLanguage::Python.site_packages(python)
    (share"glib-2.0").install_symlink python_packaging_site_packages.children

    # build patch for `ld: missing LC_LOAD_DYLIB (must link with at least libSystem.dylib) \
    # in ..gobject-introspection-1.80.1buildtestsoffsetsliboffsets-1.0.1.dylib`
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if OS.mac? && MacOS.version == :ventura

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
    system "meson", "setup", "build_staging", "-Dintrospection=disabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build_staging", "--verbose"
    system "meson", "install", "-C", "build_staging"
    ENV.append_path "PKG_CONFIG_PATH", lib"pkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", lib if OS.linux?

    resource("gobject-introspection").stage do
      system "meson", "setup", "build", "-Dcairo=disabled", "-Ddoctool=disabled", *staging_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
    ENV.append_path "PKG_CONFIG_PATH", staging_dir"libpkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", staging_dir"lib" if OS.linux?
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
    (testpath"test.c").write <<~C
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
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}glib-2.0",
                   "-I#{lib}glib-2.0include", "-L#{lib}", "-lglib-2.0"
    system ".test"

    assert_match "This file is generated by glib-mkenum", shell_output(bin"glib-mkenums")

    (testpath"net.Corp.MyApp.Frobber.xml").write <<~XML
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
    XML

    system bin"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_predicate testpath"myapp-generated.c", :exist?
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath"myapp-generated.h").read

    # Keep (u)int64_t and g(u)int64 aligned. See install comment for details
    (testpath"typecheck.cpp").write <<~CPP
      #include <cstdint>
      #include <type_traits>
      #include <glib.h>

      int main()
      {
        static_assert(std::is_same<int64_t, gint64>::value == true, "gint64 should match int64_t");
        static_assert(std::is_same<uint64_t, guint64>::value == true, "guint64 should match uint64_t");
        return 0;
      }
    CPP
    system ENV.cxx, "-o", "typecheck", "typecheck.cpp", "-I#{include}glib-2.0", "-I#{lib}glib-2.0include"
  end
end