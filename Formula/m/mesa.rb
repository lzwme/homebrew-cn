class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-25.2.4.tar.xz"
  sha256 "a370b4c549cbfbe646b319e34d73edb50ed883978f5e95133f282f0eae39ab52"
  license all_of: [
    "MIT",
    "Apache-2.0", # include/{EGL,GLES*,vk_video,vulkan}, src/egl/generate/egl.xml, src/mapi/glapi/registry/gl.xml
    "BSD-2-Clause", # src/asahi/lib/dyld_interpose.h, src/getopt/getopt*, src/util/xxhash.h
    "BSD-3-Clause", # src/compiler/glsl/float64.glsl, src/util/softfloat.*
    "BSL-1.0", # src/c11, src/gallium/auxiliary/gallivm/f.cpp
    "HPND", # src/mesa/x86/assyntax.h
    "HPND-sell-variant", # src/loader/loader_{dri,dri3,wayland}_helper.*, src/vulkan/wsi/wsi_common_display.*
    "ICU", # src/glx/*
    "MIT-Khronos-old", # src/compiler/spirv/{GLSL.*,OpenCL.std.h,spirv.core.grammar.json,spirv.h}
    "SGI-B-2.0", # src/glx/*
    :public_domain, # src/util/{dbghelp.h,u_atomic.h,sha1}, src/util/perf/gpuvis_trace_utils.h
    { "GPL-1.0-or-later" => { with: "Linux-syscall-note" } }, # include/drm-uapi/sync_file.h
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # include/drm-uapi/{d3dkmthk.h,dma-buf.h,etnaviv_drm.h}
  ]
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "86d0f81c28dd8c7df8599252a283a5394e897fb7b56c7e8872ec300bc61dd8ac"
    sha256 arm64_sequoia: "03e269771a4e573f796889d5653386febdf21f478e434f41bead89de91f583ad"
    sha256 arm64_sonoma:  "8dc87e41549edefa8111e7be2e4619a34f2c5dfd8f9acecc87c62edc9de39ecb"
    sha256 sonoma:        "2a802ab19342e844b6a1e31616cee192d6e828b4bdd349bcf4ab606cf0e94c75"
    sha256 arm64_linux:   "56af392a06d0c2ef25c3a7a2bd8725f66e638f7d99c81f8b03899f64bbd015dc"
    sha256 x86_64_linux:  "28ca14b5ee091ac9f48d01b0fccfd1a3d56a0b74351952cd1959fba6b54576a1"
  end

  depends_on "bindgen" => :build
  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "glslang" => :build
  depends_on "libxrandr" => :build
  depends_on "libxrender" => :build
  depends_on "libxshmfence" => :build
  depends_on "libyaml" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "xorgproto" => :build

  depends_on "libclc" # OpenCL support needs share/clc/*.bc files at runtime
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "llvm"
  depends_on "spirv-llvm-translator"
  depends_on "spirv-tools"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "directx-headers" => :build
    depends_on "gzip" => :build
    depends_on "libva" => :build
    depends_on "libvdpau" => :build
    depends_on "pycparser" => :build
    depends_on "valgrind" => :build
    depends_on "wayland-protocols" => :build

    depends_on "elfutils"
    depends_on "libdrm"
    depends_on "libxml2" # not used on macOS
    depends_on "libxshmfence"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"

    on_intel do
      depends_on "cbindgen" => :build
    end
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def python3
    "python3.13"
  end

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources.reject { |r| OS.mac? && r.name == "ply" }
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}" if OS.mac?

    args = %w[
      -Db_ndebug=true
      -Dgallium-rusticl=true
      -Dllvm=enabled
      -Dopengl=true
      -Dstrip=true
      -Dvideo-codecs=all
    ]
    args += if OS.mac?
      # Work around .../rusticl_system_bindings.h:1:10: fatal error: 'stdio.h' file not found
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      %W[
        -Dgallium-drivers=llvmpipe,zink
        -Dmoltenvk-dir=#{Formula["molten-vk"].prefix}
        -Dtools=etnaviv,glsl,nir,nouveau,imagination,dlclose-skip
        -Dvulkan-drivers=swrast
        -Dvulkan-layers=intel-nullhw,overlay,screenshot,vram-report-limit
      ]
    else
      # Not all supported drivers are being auto-enabled on x86 Linux.
      # TODO: Determine the explicit drivers list for ARM Linux.
      drivers = Hardware::CPU.intel? ? "all" : "auto"

      %W[
        -Degl=enabled
        -Dgallium-drivers=#{drivers}
        -Dgallium-extra-hud=true
        -Dgallium-va=enabled
        -Dgallium-vdpau=enabled
        -Dgbm=enabled
        -Dgles1=enabled
        -Dgles2=enabled
        -Dglx=dri
        -Dintel-rt=enabled
        -Dlmsensors=enabled
        -Dmicrosoft-clc=disabled
        -Dplatforms=x11,wayland
        -Dtools=drm-shim,etnaviv,freedreno,glsl,intel,nir,nouveau,lima,panfrost,asahi,imagination,dlclose-skip
        -Dvalgrind=enabled
        -Dvulkan-drivers=#{drivers}
        -Dvulkan-layers=device-select,intel-nullhw,overlay,screenshot,vram-report-limit
        --force-fallback-for=indexmap,paste,pest_generator,roxmltree,rustc-hash,syn
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    prefix.install "docs/license.rst"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    # https://gitlab.freedesktop.org/mesa/mesa/-/issues/13119
    if OS.mac?
      inreplace %W[
        #{prefix}/etc/OpenCL/vendors/rusticl.icd
        #{share}/vulkan/explicit_layer.d/VkLayer_MESA_overlay.json
        #{share}/vulkan/explicit_layer.d/VkLayer_MESA_screenshot.json
      ] do |s|
        s.gsub! ".so", ".dylib"
      end
    end
  end

  test do
    resource "glxgears.c" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/a533acd00ed0b6d1beda7df0c68a59a873dba2b3/src/xdemos/glxgears.c"
      sha256 "36376674e73fb0657fd56a3738c330b828da6731c934e2b29d75253dc02ad03b"
    end

    resource "gl_wrap.h" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
      sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
    end

    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = shell_output("pkgconf --cflags --libs gl x11 xext").chomp.split
    system ENV.cc, "glxgears.c", "-o", "gears", *flags, "-lm"
  end
end