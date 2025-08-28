class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://ghfast.top/https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.5.tar.gz"
  sha256 "91d6fbd32abcbdf030d58d3f562de25ebbc9d56040d513ff8e5c19bee9dacf14"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0b47b22819b56f4f974b3bc13229329cbef0fc1df0474a2d2ffba3ced580b2e5"
    sha256 arm64_sonoma:  "038e56d90cd6ded9ac8150847bc86c43dc57c2441496916c2a0f3b232608927c"
    sha256 arm64_ventura: "0e89003774f3a0164c890f1732242969cc013b269b037bd01d8b97a3ae4bf4a7"
    sha256 sonoma:        "d56566a7d206c7850126abbcb2c85ea659f995c30efce5886344e27aeca427e7"
    sha256 ventura:       "d90396f1c7b48efb28edfd391a82fc0a6bb83a9dd3046398f8b5a16b66a4eea3"
    sha256 x86_64_linux:  "4ef9822d552b0d2ac6d038f63539af007285ed9132e0098594ebb49ef10278c1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "lua"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sqlite"

  uses_from_macos "libedit"
  uses_from_macos "zlib"

  on_macos do
    # https://github.com/mgba-emu/mgba/issues/3129
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "mesa"
  end

  def install
    # TODO: Remove minimum policy in 0.11. Upstream commit doesn't cleanly apply
    # https://github.com/mgba-emu/mgba/commit/e95b81f1f7b95161fbda81fa5e931e3bcb193ccf
    args = ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"]
    # https://github.com/mgba-emu/mgba/issues/3115
    args << "-DUSE_DISCORD_RPC=OFF" if OS.linux?

    inreplace "src/platform/qt/CMakeLists.txt" do |s|
      # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
      s.gsub! "fixup_bundle(", "# \\0"
      # Install .app bundle into prefix, not prefix/Applications
      s.gsub! "Applications", "."
    end

    # Fix OpenGL linking on macOS.
    if OS.mac?
      inreplace "CMakeLists.txt",
                "list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES})",
                'list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES} "-framework OpenGL")'
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    if OS.mac?
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    else
      mv bin/"mgba-qt", bin/"mGBA"
    end
  end

  test do
    # mGBA opens a GUI with other commands, so we can only check the version
    assert_match version.to_s, shell_output("#{bin}/mGBA --version")
  end
end