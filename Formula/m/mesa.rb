class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  license "MIT"
  revision 1
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  stable do
    # TODO: Check if we can use unversioned `llvm` at version bump.
    url "https://mesa.freedesktop.org/archive/mesa-22.3.6.tar.xz"
    sha256 "4ec8ec65dbdb1ee9444dba72970890128a19543a58cf05931bd6f54f124e117f"

    patch do
      url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/f0a40cf7d70ee5a25639b91d9a8088749a2dd04e/mesa/fix-build-on-macOS.patch"
      sha256 "a9b646e48d4e4228c3e06d8ca28f65e01e59afede91f58d4bd5a9c42a66b338d"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "dddd482d9ce3c3039cb6e2cb723d6574d530eef7bde7c7479d67f3c527f6e3ab"
    sha256 arm64_ventura:  "23ab97f0b19d4f29bbb29f99098b03a351beb9b742a07141e5b9df6f1f28ca6d"
    sha256 arm64_monterey: "afa96fc1b42afee3f3a87a96995be248bd6c14db878137cfda97befdf77b1593"
    sha256 sonoma:         "c192ead99cce30c3144631a0bfbdab742c83c9282ed5d7a83eda8cbe1e834abe"
    sha256 ventura:        "914668e4f5dfb87ea564d63e94933ef972e3e4c9c4572171b905af9a52cf09c5"
    sha256 monterey:       "539337056f221acea7ad231bdff22ce6c3f34574f9e9b1146469070bebbdf342"
    sha256 x86_64_linux:   "c489ab18612fbafecd6c52fb8ba66eeb0c345e7587c459ac528e976e98643fa5"
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
    depends_on "llvm@15" # TODO: Change to `uses_from_macos` when this is unversioned.
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
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
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