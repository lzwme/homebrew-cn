class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-24.0.4.tar.xz"
  sha256 "90febd30a098cbcd97ff62ecc3dcf5c93d76f7fa314de944cfce81951ba745f0"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"
  bottle do
    sha256 arm64_sonoma:   "ae2d04b132bbcf41d540a855092f64327f502d09ab4cee4fbfe70fa9c2efebc4"
    sha256 arm64_ventura:  "f1e4c3f4a7f876aeba6588018abfc80c301fd217d1ac990fe94a42d0248d5da3"
    sha256 arm64_monterey: "633267ffbcde01c11dc478c0b20cad2bbbe1110ed97853e1041601876c501eec"
    sha256 sonoma:         "edb87cb52fc6ff9e44c0b368c71b3c52ad228a44519ede4bb6e878e07662bc5e"
    sha256 ventura:        "5da17175598feb34e51f62c5cc9eef08538bf53cdd02bd7e943de6e66c891791"
    sha256 monterey:       "77f4ad2b7919f114019732fef9f0f5562ef852b2bbb94d68c28a4e3c9786385b"
    sha256 x86_64_linux:   "1eea2d09e80c854f171bfff502c84d31d6874eaf9dbfe20a6066c8b78a8af336"
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

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
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