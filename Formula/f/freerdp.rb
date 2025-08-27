class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://ghfast.top/https://github.com/FreeRDP/FreeRDP/releases/download/3.17.0/freerdp-3.17.0.tar.gz"
  sha256 "5ec3f80d38421f894be3c38837e39b41965314f8ba1246faceb460d2b60869b6"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "26eeb6a13a97be705d613344b7ad50f5d91c392fa67ca29509c861ea9481be31"
    sha256 arm64_sonoma:  "359375d3ccc3da5409a5cdf365857143652bdf48d55cfedfda2dd4da45853164"
    sha256 arm64_ventura: "d9ad418f5947bcdcf9dd717a9b2bf0e3b3ebd5ed06c09567c60eab781e5c3a78"
    sha256 sonoma:        "0c4782fe8127328d4123a4dbe8c0a8426e48d8f7a0f7050d806b263c0301312e"
    sha256 ventura:       "31a22ef5d15c7a067313685333c62551a8eb67af50d67c2026d03ccd69caa482"
    sha256 arm64_linux:   "03ee442d85703db8dce1318dbb108fe1255e99c535c3b1ad29d98f27b14acec4"
    sha256 x86_64_linux:  "ccc460341c5c24e0fd9bc62a80f2be413391f4aab40cdb46b8e94af52c3fef95"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on "libxrender"
  depends_on "libxv"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "sdl3"
  depends_on "sdl3_ttf"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "icu4c@77"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_X11=ON
      -DWITH_JPEG=ON
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=ON
      -DWITH_CLIENT_SDL2=OFF
      -DWITH_CLIENT_SDL3=ON
    ]

    # Native macOS client and server implementations are unmaintained and use APIs that are obsolete on Sequoia.
    # Ref: https://github.com/FreeRDP/FreeRDP/issues/10558
    if OS.mac? && MacOS.version >= :sequoia
      # As a workaround, force X11 shadow server implementation. Can use -DWITH_SHADOW=OFF if it doesn't work
      inreplace "server/shadow/CMakeLists.txt", "add_subdirectory(Mac)", "add_subdirectory(X11)"

      args += ["-DWITH_CLIENT_MAC=OFF", "-DWITH_PLATFORM_SERVER=OFF"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    extra = ""
    on_macos do
      extra = <<~EOS

        XQuartz provides an XServer for macOS. The XQuartz can be installed
        as a package from www.xquartz.org or as a Homebrew cask:
          brew install --cask xquartz
      EOS
    end

    <<~EOS
      xfreerdp is an X11 application that requires an XServer be installed
      and running. Lack of a running XServer will cause a "$DISPLAY" error.
      #{extra}
    EOS
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end