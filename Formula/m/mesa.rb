class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  stable do
    url "https://mesa.freedesktop.org/archive/mesa-23.3.3.tar.xz"
    sha256 "518307c0057fa3cee8b58df78be431d4df5aafa7edc60d09278b2d7a0a80f3b4"

    # Backport macOS build fixes from HEAD.
    # Ref: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/25992
    on_macos do
      patch :DATA # https://gitlab.freedesktop.org/mesa/mesa/-/commit/96d55d784cb4f047a4b58cd08330f42208641ea7
      patch do
        url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/c8b64452c076c1768beb23280de25faf2bcbe2c8.diff"
        sha256 "0404bf72f10c991444b22721c5a7801aa6f788d2e6efdd9884a074834e0e0b31"
      end
      patch do
        url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/4ef573735efc7f15d8b8700622a5865d33c34bf1.diff"
        sha256 "df09ac99747aa0a79c4342b8233739c4b5e4eeee7bcba4473783cff299aae5e3"
      end
    end
  end

  bottle do
    sha256 arm64_sonoma:   "a997fe3dc9dcfdf44635733474023417ef60e22c8a7e6a559caa100820e2d0c7"
    sha256 arm64_ventura:  "b2e379d382bf0a2444bb2def3610a9e1175c2ba6f8c53be61291a84b85a38e6f"
    sha256 arm64_monterey: "1cd7ed3c7e0395568d8b071e6b2c38940a47e56c56c142fbce512d7a26dee373"
    sha256 sonoma:         "5117b9f1cef5029387e100c856c04b43e3f570b2435e808b2ba6f9d2e03a6269"
    sha256 ventura:        "e05c44345504db5d5681c1310152d74a982c16071b67a7145b46e47d3bf2f84d"
    sha256 monterey:       "c643eb6470b96ceb4264938860907cdb19c0642da239192654ad91054a2a0cc3"
    sha256 x86_64_linux:   "cbe4c3dbd2f2ebb5dfca8116ccfb2f868e48434c78942b5cc39e2ba7a46c7687"
  end

  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments" => :build
  depends_on "python-mako" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "xorgproto" => :build

  depends_on "expat"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "flex" => :build
  uses_from_macos "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "glslang"
    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/caac7be425a185e191224833375413772c4aff8d/src/xdemos/glxgears.c"
    sha256 "344a03aff01708350d90603fd6b841bccd295157670f519b459bbf3874acf847"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
  end

  def install
    args = ["-Db_ndebug=true"]
    compile_args = []

    if OS.linux?
      args += %w[
        -Dplatforms=x11,wayland
        -Dglx=auto
        -Ddri3=enabled
        -Dgallium-drivers=auto
        -Dgallium-omx=disabled
        -Degl=enabled
        -Dgbm=enabled
        -Dopengl=true
        -Dgles1=enabled
        -Dgles2=enabled
        -Dvalgrind=disabled
        -Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,lima
      ]
      # Work around fatal error: vtn_generator_ids.h: No such file or directory
      # Issue ref: https://gitlab.freedesktop.org/mesa/mesa/-/issues/10277
      compile_args << "--jobs=1"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose", *compile_args
    system "meson", "install", "-C", "build"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    if OS.linux?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["libx11"].lib}
      -L#{Formula["libxext"].lib}
      -lGL
      -lX11
      -lXext
      -lm
    ]
    system ENV.cc, "glxgears.c", "-o", "gears", *flags
  end
end

__END__
diff --git a/src/util/libdrm.h b/src/util/libdrm.h
index cc153cf..045d724 100644
--- a/src/util/libdrm.h
+++ b/src/util/libdrm.h
@@ -33,6 +33,7 @@

 #include <errno.h>
 #include <stdint.h>
+#include <sys/types.h>

 #define DRM_NODE_PRIMARY 0
 #define DRM_NODE_CONTROL 1
@@ -44,22 +45,79 @@
 #define DRM_BUS_PLATFORM  2
 #define DRM_BUS_HOST1X    3

+typedef struct _drmPciDeviceInfo {
+    uint16_t vendor_id;
+    uint16_t device_id;
+    uint16_t subvendor_id;
+    uint16_t subdevice_id;
+    uint8_t revision_id;
+} drmPciDeviceInfo, *drmPciDeviceInfoPtr;
+
+#define DRM_PLATFORM_DEVICE_NAME_LEN 512
+
+typedef struct _drmPlatformBusInfo {
+    char fullname[DRM_PLATFORM_DEVICE_NAME_LEN];
+} drmPlatformBusInfo, *drmPlatformBusInfoPtr;
+
+typedef struct _drmPlatformDeviceInfo {
+    char **compatible; /* NULL terminated list of compatible strings */
+} drmPlatformDeviceInfo, *drmPlatformDeviceInfoPtr;
+
+#define DRM_HOST1X_DEVICE_NAME_LEN 512
+
+typedef struct _drmHost1xBusInfo {
+    char fullname[DRM_HOST1X_DEVICE_NAME_LEN];
+} drmHost1xBusInfo, *drmHost1xBusInfoPtr;
+
+typedef struct _drmPciBusInfo {
+   uint16_t domain;
+   uint8_t bus;
+   uint8_t dev;
+   uint8_t func;
+} drmPciBusInfo, *drmPciBusInfoPtr;
+
 typedef struct _drmDevice {
     char **nodes; /* DRM_NODE_MAX sized array */
     int available_nodes; /* DRM_NODE_* bitmask */
     int bustype;
+    union {
+       drmPciBusInfoPtr pci;
+       drmPlatformBusInfoPtr platform;
+       drmHost1xBusInfoPtr host1x;
+    } businfo;
+    union {
+        drmPciDeviceInfoPtr pci;
+    } deviceinfo;
     /* ... */
 } drmDevice, *drmDevicePtr;

+static inline int
+drmGetDevice2(int fd, uint32_t flags, drmDevicePtr *device)
+{
+   return -ENOENT;
+}
+
 static inline int
 drmGetDevices2(uint32_t flags, drmDevicePtr devices[], int max_devices)
 {
    return -ENOENT;
 }

+static inline int
+drmGetDeviceFromDevId(dev_t dev_id, uint32_t flags, drmDevicePtr *device)
+{
+   return -ENOENT;
+}
+
+static inline void
+drmFreeDevice(drmDevicePtr *device) {}
+
 static inline void
 drmFreeDevices(drmDevicePtr devices[], int count) {}

+static inline char*
+drmGetDeviceNameFromFd2(int fd) { return NULL;}
+
 typedef struct _drmVersion {
     int     version_major;        /**< Major version */
     int     version_minor;        /**< Minor version */