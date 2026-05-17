class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://ghfast.top/https://github.com/hrydgard/ppsspp/releases/download/v1.20.4/ppsspp-1.20.4.tar.xz"
  sha256 "4de21db3105d9d81a465a8a7e78c68ee3c0e0bf6597d1c1d530f7555f3ad8b31"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "463c172edc891360f52a17fb04fafe771d3f8bc8a7efddf08d8aee3edf1be25f"
    sha256 cellar: :any, arm64_sequoia: "37dccc9e4b8a6207c2f2d892a05e2102d5b0a4232dc6ed8093ee80096bc03477"
    sha256 cellar: :any, arm64_sonoma:  "17637b0dd8d1802ce22e47db93aff44270c4388530e7f82f95400ea7c44a85f8"
    sha256 cellar: :any, sonoma:        "76ca2f5322fa7e4fc114025f8a976557c72e7d2f9f0d38df727750023c6b1c98"
    sha256               arm64_linux:   "cd159a025e2681cb590cadb56c6e700cb5ef9deb68a8f4aa9b3ff67657769be8"
    sha256               x86_64_linux:  "69dbbeff7c7e0dde71f68a8cc93ec9a0c1d3cfec891b720fca5cebf28f6a5a58"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "yasm" => :build

  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_r("macosx")
        system "./mac-build.sh"
      else
        rm_r("linux")
        arch = Hardware::CPU.intel? ? "x86-64" : Hardware::CPU.arch
        system "./linux_#{arch}.sh"
      end
    end

    # Workaround for error: use of undeclared identifier `fseeko|ftello|ftruncate`
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    args = %w[
      -DUSE_SYSTEM_LIBZIP=ON
      -DUSE_SYSTEM_SNAPPY=ON
      -DUSE_SYSTEM_LIBSDL2=ON
      -DUSE_SYSTEM_LIBPNG=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DUSE_SYSTEM_MINIUPNPC=ON
      -DUSE_WAYLAND_WSI=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      prefix.install "build/PPSSPPSDL.app"
      bin.write_exec_script prefix/"PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"

      # Replace app bundles with symlinks to allow dependencies to be updated
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
    else
      system "cmake", "--install", "build"
    end

    bin.install_symlink "PPSSPPSDL" => "ppsspp"
  end

  test do
    system bin/"ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_path_exists app_frameworks/"libMoltenVK.dylib", "Broken linkage with `molten-vk`"
    end
  end
end