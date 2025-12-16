class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://ghfast.top/https://github.com/hrydgard/ppsspp/releases/download/v1.19.3/ppsspp-1.19.3.tar.xz"
  sha256 "054401fa7fffbd99b7fd80e98a2951d6f0c3de83cb4b54719899c98bfad99614"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba081e90098ef595823c51bd0905005d5064eccec9fe7a2ab5cdd28bb7f6beb9"
    sha256 cellar: :any, arm64_sequoia: "c52b76eec8f4d933a4a5a6d160b9b753c1f0e4fad97f500b953bc32ae4717670"
    sha256 cellar: :any, arm64_sonoma:  "46aebb39a4f125ecfde641e0ba89f6abc01ce3afcdcf9017c56608f22113feb2"
    sha256 cellar: :any, sonoma:        "7cbe7e5b1ee008c846e9dd75900f85483fd7672882373f313e7bb37cb5fa18b1"
    sha256               arm64_linux:   "8b9509f8cca92b1b7ea3ad47c4f3275b0ad24ac45cd6e2eac8891148764c77b6"
    sha256               x86_64_linux:  "e5be3400883cef9c47ed65e3fa02ff499d605364b0af88f0093b5ea1e84beed7"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
    depends_on "mesa"
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