class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https:ppsspp.org"
  url "https:github.comhrydgardppsspp.git",
      tag:      "v1.16.6",
      revision: "ba0ce344937d17e177ec8656ab957f6b82facdda"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https:github.comhrydgardppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47743b26e05da06f873cfc04140c7b06fa05e4d2878b177bbce19695e9990693"
    sha256 cellar: :any,                 arm64_ventura:  "477f6c0718844fe2bee283824073b18fff2c7f4c0deecafb4a1a852f4402ab1a"
    sha256 cellar: :any,                 arm64_monterey: "b74129bc74e529fe429de60955418b48bf11478d06c42435b88b103cd0de7143"
    sha256 cellar: :any,                 sonoma:         "22bfd4e83895801d990cc5d54245437dfcc3d9b90cd457c3390623965fbdb290"
    sha256 cellar: :any,                 ventura:        "17545beac5230b6d3e25496b70bce39df3b1fe0c9117055f90d40dff044c0256"
    sha256 cellar: :any,                 monterey:       "644a686a432655322b4a3bbf528519849e2110ea91600164996caadfc0830e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5777f180bccc80ae3d8707f70d97c026def886899528bb52c15e7f67c90da634"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
  end

  on_intel do
    # ARM uses a bundled, unreleased libpng.
    # Make unconditional when we have libpng 1.7.
    depends_on "libpng"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https:github.comHomebrewhomebrew-coreissues84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_rf "macosx"
        system ".mac-build.sh"
      else
        rm_rf "linux"
        system ".linux_x86-64.sh"
      end
    end

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath"extvulkanmacOSFrameworks"
    (vulkan_frameworks"libMoltenVK.dylib").unlink
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib"libMoltenVK.dylib"

    mkdir "build" do
      args = std_cmake_args + %w[
        -DUSE_SYSTEM_LIBZIP=ON
        -DUSE_SYSTEM_SNAPPY=ON
        -DUSE_SYSTEM_LIBSDL2=ON
        -DUSE_SYSTEM_LIBPNG=ON
        -DUSE_SYSTEM_ZSTD=ON
        -DUSE_SYSTEM_MINIUPNPC=ON
        -DUSE_WAYLAND_WSI=OFF
      ]

      system "cmake", "..", *args
      system "make"

      if OS.mac?
        prefix.install "PPSSPPSDL.app"
        bin.write_exec_script "#{prefix}PPSSPPSDL.appContentsMacOSPPSSPPSDL"
        mv "#{bin}PPSSPPSDL", "#{bin}ppsspp"

        # Replace app bundles with symlinks to allow dependencies to be updated
        app_frameworks = prefix"PPSSPPSDL.appContentsFrameworks"
        ln_sf (Formula["molten-vk"].opt_lib"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
      else
        bin.install "PPSSPPSDL" => "ppsspp"
      end
    end
  end

  test do
    system "#{bin}ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix"PPSSPPSDL.appContentsFrameworks"
      assert_predicate app_frameworks"libMoltenVK.dylib", :exist?, "Broken linkage with `molten-vk`"
    end
  end
end