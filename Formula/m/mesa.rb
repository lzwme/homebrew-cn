class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-24.0.0.tar.xz"
  sha256 "dc7e8c077bc5884df95478263b34bdebb7e88e600689cb56fb07be2b8c304c36"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"
  bottle do
    sha256 arm64_sonoma:   "f2c899b05563637a98bcb9c6676b7ecd3cf5008415fbaf4295d250f225d174e6"
    sha256 arm64_ventura:  "c8652dc49ca60c8f0c70171f4d6fd10ffbc2a54d221a6cf5f34b980898788020"
    sha256 arm64_monterey: "82e91ecdfa8b9bad1c2d7ffcf756210ba793f9e9c0d18f666b53ce7b9e68ab2b"
    sha256 sonoma:         "bd7caf2c6bcf109497320fb7d8c5c7dc13e1ccfd349fb88597b15ea035bd3db2"
    sha256 ventura:        "d4ed324d128da77fa28954a2256d6448243e10894c8f63fa6cd0cd02185f5178"
    sha256 monterey:       "e4f1b92456108f22b8f82589cac74e888dce3568adbd9ad44300f527aaf40b36"
    sha256 x86_64_linux:   "1f8ddff6338be0cb292615125d13c95962c30ddb6ab3436ac1d035f6c71abbd2"
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
    depends_on "libclc"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "python-ply"
    depends_on "spirv-llvm-translator"
    depends_on "valgrind"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/391cafee6d43a28afaf87a269475e0ede7d97469/src/xdemos/glxgears.c"
    sha256 "294d7b9984eb1194a110a5a5500878df8b8d7b7922ec56257e9d8d8ae5e578e6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
  end

  def install
    args = %w[
      -Db_ndebug=true
      -Dosmesa=true
    ]

    if OS.mac?
      args += %w[
        -Dgallium-drivers=swrast
      ]
    end

    if OS.linux?
      args += %w[
        -Ddri3=enabled
        -Degl=enabled
        -Dgallium-drivers=r300,r600,radeonsi,nouveau,virgl,svga,swrast,i915,iris,crocus,zink
        -Dgallium-extra-hud=true
        -Dgallium-nine=true
        -Dgallium-omx=disabled
        -Dgallium-opencl=icd
        -Dgallium-va=enabled
        -Dgallium-vdpau=enabled
        -Dgallium-xa=enabled
        -Dgbm=enabled
        -Dgles1=enabled
        -Dgles2=enabled
        -Dglx=dri
        -Dintel-clc=enabled
        -Dlmsensors=enabled
        -Dllvm=enabled
        -Dmicrosoft-clc=disabled
        -Dopengl=true
        -Dplatforms=x11,wayland
        -Dshared-glapi=enabled
        -Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,lima
        -Dvalgrind=enabled
        -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc
        -Dvulkan-drivers=amd,intel,intel_hasvk,swrast,virtio
        -Dvulkan-layers=device-select,intel-nullhw,overlay
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