class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-24.1.3.tar.xz"
  sha256 "63236426b25a745ba6aa2d6daf8cd769d5ea01887b0745ab7124d2ef33a9020d"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "c9608d55b2ce367322aaabf4fa8e9a0adf8fe713d45d9becc25f88a46a4d8c9d"
    sha256 arm64_ventura:  "e1d1cea5ade94e0697004b0be63930a10733f830e7d9cb7095ed03d56a45f960"
    sha256 arm64_monterey: "25cfbe67ba36a1e5cfeb8eb5e785d6feed68f2a7d7c7a81a7eca16287b5736b4"
    sha256 sonoma:         "49e17978a6c253b474b908c939f846ca42a76899ac1bc47655dc679ea9a38505"
    sha256 ventura:        "d6f8849eb44935df108f768da871b15473b66cf7d8195d6b71af4f9db06e4940"
    sha256 monterey:       "ee3148cc08275d010a2a53536b14cb878e4dd69de8bfa8c1febf5926b0331c7c"
    sha256 x86_64_linux:   "b374d6eb1a243794bae54fd1b4d00df02dda10fac73ba0100e2a14aedfa922e7"
  end

  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "xorgproto" => :build

  depends_on "expat"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"
  depends_on "libxrandr"

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
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "spirv-llvm-translator"
    depends_on "valgrind"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/878cd7fb84b7712d29e5d1b38355ed9c5899a403/src/xdemos/glxgears.c"
    sha256 "af7927d14bd9cc989347ad0c874b35c4bfbbe9f408956868b1c5564391e21eed"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/67/03/fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddb/Mako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "ply" do
    on_linux do
      url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
      sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
    end
  end

  def python3
    "python3.12"
  end

  def install
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, python3)

    python_resources = resources.to_set(&:name) - ["glxgears.c", "gl_wrap.h"]
    python_resources.each do |r|
      venv.pip_install resource(r)
    end
    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python3)
    ENV.prepend_path "PATH", venv_root/"bin"

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