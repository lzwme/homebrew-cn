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
    sha256 arm64_sequoia: "d84c427fa40fa6af478102d049710e0b142573ed5c29b80b222543a147d0e383"
    sha256 arm64_sonoma:  "47c9d1dbf50da51e8d04620659d27942e883fd164607accc11db889c9fb7be76"
    sha256 arm64_ventura: "7d1d979c7b67165a49915c22a1a1bb1a118a09d776981527ea7949374107dbbc"
    sha256 sonoma:        "2d9ecdc2d6e1b3b7da10e863971bb8d3d626ea75f6f8887e210a6daea9af1f76"
    sha256 ventura:       "fe1395b1ff6804ec4bffff750f68bcc14bb8ea69401eec620bb3f649af7bc9d7"
    sha256 x86_64_linux:  "a39d91982ebe6dc87e5ffb5e2268711e28b1db181aa110c530fd2de56c50e704"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg@7"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libsamplerate"
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