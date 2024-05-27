class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.76/vte-0.76.2.tar.xz"
  sha256 "e3dc6082d5bd70f8aafaaad2cdfcaf7e51da6ba00a919b11ddac6efa09c72847"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "86c2a87641d2df8e6e6aaad39c78e5e6dfd524729c027f482def21fb5cec8b2e"
    sha256 arm64_ventura:  "21664f5dbe45e9d26c8c52935652d7cf7ed21ba6c273a4cd2f2a6cb35a588eaa"
    sha256 arm64_monterey: "39ff3653ae76eef0ccfbbdd2d2447063a5d7871133070b5980e8166958c14fe5"
    sha256 sonoma:         "b04bca49c1763e9f8f2fdba4db8d4884a0a66b4fc4944bde48bc570a92ad819a"
    sha256 ventura:        "7996c79188fb6478dd23a425dbe8c3a6b1506ae9ff70ef4e16658f67a4356b13"
    sha256 monterey:       "00d59653c03b228961e4cbc6d7fb445d508d675d73162585c683ecc190dac183"
    sha256 x86_64_linux:   "4b9cadb9c7ad1378ee41db1a694e573ae766fc2e2e679990421b7916e12981ec"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c"
  depends_on "lz4"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
  end

  on_ventura :or_newer do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_monterey :or_older do
    # We use GCC on older macOS as build fails with brew `llvm`.
    # Undefined symbols for architecture x86_64:
    #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from: ...
    depends_on "gcc"
    fails_with :clang
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "systemd"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # submitted upstream as https://gitlab.gnome.org/tschoonj/vte/merge_requests/1
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && MacOS.version >= :ventura && DevelopmentTools.clang_build_version <= 1500
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version == 1500

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dgir=true",
                                      "-Dgtk3=true",
                                      "-Dgtk4=true",
                                      "-Dgnutls=true",
                                      "-Dvapi=true",
                                      "-D_b_symbolic_functions=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    (testpath/"test.c").write <<~EOS
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkg-config --cflags --libs vte-2.91-gtk4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index e2200a75..df98872f 100644
--- a/meson.build
+++ b/meson.build
@@ -78,6 +78,8 @@ lt_age = vte_minor_version * 100 + vte_micro_version - lt_revision
 lt_current = vte_major_version + lt_age

 libvte_gtk3_soversion = '@0@.@1@.@2@'.format(libvte_soversion, lt_current, lt_revision)
+osx_version_current = lt_current + 1
+libvte_gtk3_osxversions = [osx_version_current, '@0@.@1@.0'.format(osx_version_current, lt_revision)]
 libvte_gtk4_soversion = libvte_soversion.to_string()

 # i18n
diff --git a/src/meson.build b/src/meson.build
index 79d4a702..0495dea8 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -224,6 +224,7 @@ if get_option('gtk3')
     vte_gtk3_api_name,
     sources: libvte_gtk3_sources,
     version: libvte_gtk3_soversion,
+    darwin_versions: libvte_gtk3_osxversions,
     include_directories: incs,
     dependencies: libvte_gtk3_deps,
     cpp_args: libvte_gtk3_cppflags,