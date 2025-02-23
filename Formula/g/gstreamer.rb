class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https:gstreamer.freedesktop.org"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1

  stable do
    url "https:gitlab.freedesktop.orggstreamergstreamer-archive1.24.12gstreamer-1.24.12.tar.bz2"
    sha256 "23c0e1de51ce96be8ef26c79f9b971a11ab82c8e6267cea8c3933ede28fba155"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs-archivegstreamer-1.24.12gst-plugins-rs-gstreamer-1.24.12.tar.bz2"
      sha256 "da0a07f5163c59da00b1306be4843d2a2b6849c87a8af470e04fb91afbf8da3d"

      livecheck do
        formula :parent
      end

      # Backport support for newer `dav1d`
      # upstream commit ref, https:gitlab.freedesktop.orggstreamergst-plugins-rs-commit7e1ab086de00125bc0d596f9ec5d74c9b82b2cc0
      patch do
        url "https:raw.githubusercontent.comHomebrewformula-patches6fff2c4c62f1fb32b5ade46ec9246fc239935d7agstreamergst-plugins-rs-dav1d.patch"
        sha256 "d17677a523af021b226969937550f19151b8042f6962eae9fa39ee0e0fc0fe3a"
      end
    end
  end

  livecheck do
    url "https:gstreamer.freedesktop.orgsrcgstreamer"
    regex(href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "bf3974990e4a3446e2e31b08b4a8ad8f13028693bf3977e272538aa0f95bd277"
    sha256 arm64_sonoma:  "99df12a0ff7622aac46873d224a7257361222bf13e714826144cbd6fb4480569"
    sha256 arm64_ventura: "c6d1c6ee4eeb7bd08a805ad5f20cd25f4a95c77b19445872507d046a7f9d214c"
    sha256 sonoma:        "3d0a8846b64771753d1e1dd09229c7ff9c24209b1c59adf1228ec687ebf05fef"
    sha256 ventura:       "3a6beeddea440868b56f595e205bd6fb4ebac5f04b77723c09a434c5b536a143"
    sha256 x86_64_linux:  "7277b9f2ede925d0e153aaa1c11de3b6f8cbe70c35b17d23836c752984971beb"
  end

  head do
    url "https:gitlab.freedesktop.orggstreamergstreamer.git", branch: "main"

    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs.git", branch: "main"
    end
  end

  depends_on "bison" => :build
  depends_on "cargo-c" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "aom"
  depends_on "cairo"
  depends_on "dav1d"
  depends_on "faac"
  depends_on "faad2"
  depends_on "fdk-aac"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "lame"
  depends_on "libass"
  depends_on "libnice"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsodium"
  depends_on "libsoup" # no linkage on Linux as dlopen'd
  depends_on "libusrsctp"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxtst"
  depends_on "little-cms2"
  depends_on "mpg123"
  depends_on "nettle"
  depends_on "opencore-amr"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "pygobject3"
  depends_on "python@3.13"
  depends_on "rtmpdump"
  depends_on "speex"
  depends_on "srt"
  depends_on "srtp"
  depends_on "svt-av1"
  depends_on "taglib"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    # musepack is not bottled on Linux
    # https:github.comHomebrewhomebrew-corepull92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libxdamage"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
  end

  def python3
    which("python3.13")
  end

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bingst-*", "libligst*", "liblibges*", "libgirepository-1.0Gst*-1.0.typelib"
  link_overwrite "libgirepository-1.0GES-1.0.typelib", "libgst-validate-launcher*", "libgstreamer-1.0*"
  link_overwrite "libpkgconfiggst*.pc", "libpython3.13site-packagesgioverrides*", "includegstreamer-1.0*"
  link_overwrite "sharegir-1.0Gst*.gir", "sharegir-1.0GES-1.0.gir", "sharegstreamer-1.0*"
  link_overwrite "sharelocale*LC_MESSAGESgst-*.mo", "sharemanman1g*"

  # Avoid overlinking of `gst-python` python extension module.
  # https:gitlab.freedesktop.orggstreamergst-python-merge_requests41
  # TODO: Migrate patch to gstreamer monorepo.
  patch :DATA

  def install
    odie "rs resource needs to be updated" if build.stable? && version != resource("rs").version

    (buildpath"subprojectsgst-plugins-rs").install resource("rs")

    site_packages = Language::Python.site_packages(python3)
    # To pass arguments to subprojects (e.g. `gst-editing-services`), use
    #   -Dsubproject:option=value
    args = %W[
      -Dpython.platlibdir=#{site_packages}
      -Dpython.purelibdir=#{site_packages}
      -Dpython=enabled
      -Dlibav=enabled
      -Dlibnice=disabled
      -Dbase=enabled
      -Dgood=enabled
      -Dugly=enabled
      -Dbad=enabled
      -Ddevtools=enabled
      -Dges=enabled
      -Drtsp_server=enabled
      -Drs=enabled
      -Dtls=enabled
      -Dqt5=disabled
      -Dtools=enabled
      -Dorc-source=system
      -Dgpl=enabled
      -Dtests=disabled
      -Dexamples=disabled
      -Dnls=enabled
      -Dorc=enabled
      -Ddoc=disabled
      -Dgtk_doc=disabled
      -Dintrospection=enabled
      -Dpackage-origin=#{tap.default_remote}
      -Dgst-devtools:validate=enabled
      -Dgst-devtools:cairo=enabled
      -Dgst-editing-services:pygi-overrides-dir=#{site_packages}gioverrides
      -Dgst-python:pygi-overrides-dir=#{site_packages}gioverrides
      -Dgst-python:python=#{python3}
      -Dgst-plugins-bad:opencv=disabled
      -Dgst-plugins-bad:sctp=enabled
      -Dgst-plugins-bad:sctp-internal-usrsctp=disabled
      -Dgst-plugins-good:soup=enabled
      -Dgst-plugins-rs:closedcaption=enabled
      -Dgst-plugins-rs:dav1d=enabled
      -Dgst-plugins-rs:sodium=enabled
      -Dgst-plugins-rs:csound=disabled
      -Dgst-plugins-rs:gtk4=enabled
      -Dgst-plugins-rs:sodium-source=system
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "-Dgst-plugins-bad:applemedia=disabled" if OS.mac? && MacOS.version <= :high_sierra

    # Ban trying to chown to root.
    # https:bugzilla.gnome.orgshow_bug.cgi?id=750367
    args << "-Dgstreamer:ptp-helper-permissions=none"

    # Prevent the build from downloading an x86-64 version of bison.
    args << "-Dbuild-tools-source=system"

    # Set `RPATH` since `cargo-c` doesn't seem to.
    # https:gitlab.freedesktop.orggstreamergst-plugins-rs-issues279
    plugin_dir = lib"gstreamer-1.0"
    rpath_args = [loader_path, rpath(source: plugin_dir)].map { |path| "-rpath,#{path}" }
    ENV.append "RUSTFLAGS", "--codegen link-args=-Wl,#{rpath_args.join(",")}"
    inreplace "subprojectsgst-plugins-rscargo_wrapper.py",
              "env['RUSTFLAGS'] = shlex_join(rust_flags)",
              "env['RUSTFLAGS'] = ' '.join(rust_flags)"

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # Support finding the `libnice` plugin, which is in a separate formula.
    # Needs to be done in `post_install`, since bottling prunes this symlink.
    libnice_gst_plugin = Formula["libnice-gstreamer"].opt_libexec"gstreamer-1.0"shared_library("libgstnice")
    gst_plugin_dir = lib"gstreamer-1.0"
    ln_sf libnice_gst_plugin.relative_path_from(gst_plugin_dir), gst_plugin_dir
  end

  def caveats
    <<~EOS
      All gst-* GStreamer plugins are now bundled in this formula.
      For GStreamer to find your own plugins, add their paths to `GST_PLUGIN_PATH`.
      For example, if you have plugins in `~.locallibgstreamer-1.0`:
        export GST_PLUGIN_PATH="~.locallibgstreamer-1.0"

      Do not install plugins into GStreamer's prefix. They will be deleted
      by `brew upgrade`.
    EOS
  end

  test do
    # TODO: Improve test according to suggestions at
    #   https:github.comorgsHomebrewdiscussions3740
    system bin"gst-validate-launcher", "--usage"

    system python3, "-c", <<~PYTHON
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    PYTHON

    # FIXME: The initial plugin load takes a long time without extra permissions on
    # macOS, which frequently causes the slower Intel macOS runners to time out.
    # Need to allow a longer timeout or see if CI terminal can be made a developer tool.
    #
    # Ref: https:gitlab.freedesktop.orggstreamergstreamer-issues1119
    skip_plugins = OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    ENV["GST_PLUGIN_SYSTEM_PATH"] = testpath if skip_plugins

    assert_match(^Total count: \d+ plugin, shell_output(bin"gst-inspect-1.0"))
    return if skip_plugins

    system bin"ges-launch-1.0", "--ges-version"
    system bin"gst-inspect-1.0", "libav"
    system bin"gst-inspect-1.0", "--plugin", "dvbsuboverlay"
    system bin"gst-inspect-1.0", "--plugin", "fdkaac"
    system bin"gst-inspect-1.0", "--plugin", "volume"
    system bin"gst-inspect-1.0", "--plugin", "cairo"
    system bin"gst-inspect-1.0", "--plugin", "dvdsub"
    system bin"gst-inspect-1.0", "--plugin", "x264"
    system bin"gst-inspect-1.0", "--plugin", "rtspclientsink"
    system bin"gst-inspect-1.0", "--plugin", "rsfile"
    system bin"gst-inspect-1.0", "hlsdemux2"
  end
end

__END__
diff --git asubprojectsgst-pythongioverridesmeson.build bsubprojectsgst-pythongioverridesmeson.build
index 20aeb06ac9..3c53eab6d7 100644
--- asubprojectsgst-pythongioverridesmeson.build
+++ bsubprojectsgst-pythongioverridesmeson.build
@@ -7,8 +7,10 @@ python.install_sources(pysources,
 host_system = host_machine.system()
 if host_system == 'windows'
   gst_dep_for_gi = gst_dep
+  python_ext_dep = python_dep
 else
   gst_dep_for_gi = gst_dep.partial_dependency(compile_args: true, includes: true, sources: true)
+  python_ext_dep = python_dep.partial_dependency(compile_args: true)
 endif

 gstpython = python.extension_module('_gi_gst',
@@ -17,7 +19,7 @@ gstpython = python.extension_module('_gi_gst',
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep_for_gi, python_dep, pygobject_dep],
+    dependencies : [gst_dep_for_gi, python_ext_dep, pygobject_dep],
 )

 env = environment()