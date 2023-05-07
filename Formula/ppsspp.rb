class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.15.2",
      revision: "4d4c325765c4f8d08a80b30d496c2fa28af68710"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03506b27029301736eec69fe74c69aa4429520a2b50100c988cc3aaa56d7f418"
    sha256 cellar: :any,                 arm64_monterey: "31fd5ac678db0d282408462a0d274c109d40dc63f8c28914a40b3b009054dcff"
    sha256 cellar: :any,                 arm64_big_sur:  "383251b960eecd45284d65dfdbdcc0658a840f14f4456efb73f648c9bb467b9b"
    sha256 cellar: :any,                 ventura:        "e3f0fc9825c2109069fee5384b7ea1eec2e4659f7009b39c71d9dba692a15412"
    sha256 cellar: :any,                 monterey:       "3f06c64e84ad71fa9264c307eabde2639e16452ea711df8eb211ebe7b67f3fd1"
    sha256 cellar: :any,                 big_sur:        "906eb34bc999b20153c6c1d19dd9f57074774c0cad13837cb07385262a148b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8078ccccd3f481face65aded1c2f0cf25289a8ce69819de890038dfdf5edb3"
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

  # Support using brewed SDL2.
  # Remove once https://github.com/hrydgard/ppsspp/pull/17413 lands in a tag.
  patch do
    url "https://github.com/hrydgard/ppsspp/commit/8ef17b166299bcec1bfa2617b7ec54d755b9ab60.patch?full_index=1"
    sha256 "5f9f49a41f28ef0c50177b91d01bb043bb6a111f23cb6633c0fb9a759ea7da86"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_rf "macosx"
        system "./mac-build.sh"
      else
        rm_rf "linux"
        system "./linux_x86-64.sh"
      end
    end

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    (vulkan_frameworks/"libMoltenVK.dylib").unlink
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    mkdir "build" do
      args = std_cmake_args + %w[
        -DUSE_SYSTEM_LIBZIP=ON
        -DUSE_SYSTEM_SNAPPY=ON
        -DUSE_SYSTEM_LIBSDL2=ON
        -DUSE_SYSTEM_LIBPNG=ON
        -DUSE_SYSTEM_ZSTD=ON
        -DUSE_SYSTEM_MINIUPNPC=ON
      ]

      system "cmake", "..", *args
      system "make"

      if OS.mac?
        prefix.install "PPSSPPSDL.app"
        bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
        mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"

        # Replace app bundles with symlinks to allow dependencies to be updated
        app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
        ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
      else
        bin.install "PPSSPPSDL" => "ppsspp"
      end
    end
  end

  test do
    system "#{bin}/ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_predicate app_frameworks/"libMoltenVK.dylib", :exist?, "Broken linkage with `molten-vk`"
    end
  end
end