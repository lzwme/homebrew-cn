class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://ghfast.top/https://github.com/hrydgard/ppsspp/releases/download/v1.20.1/ppsspp-1.20.1.tar.xz"
  sha256 "063b224adc25c2b28e01c36033fff9b96e9e2b8d1004c6bb5db3d6f1b83b2e20"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a56a20f8c60a1c070d903023b64234dd68f638a23a54878d64896b8af096ddb"
    sha256 cellar: :any, arm64_sequoia: "bc764a9bf2aa9af483d8284cf1063bcbecc688d2d303e50513b98f423771d5fa"
    sha256 cellar: :any, arm64_sonoma:  "236891110aea37463c524de448131c8ec6de9c3ac660d3b99c37bffdaaad57c2"
    sha256 cellar: :any, sonoma:        "487e9aa6a3b5df4dde737e09d9eb0435df2d5a4976f95231c7676590bd883141"
    sha256               arm64_linux:   "de7e2e44697fb6b2d1d69ebdde8aad4e39983f8726ec683ca87407796987b06c"
    sha256               x86_64_linux:  "1bfc04239950a84341a6042daa35f9f9177856ced9e3837db47c99c8e930472b"
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