class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://ghfast.top/https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.27.1.tar.gz"
  sha256 "929ac6a5a8651fcf524e0f061aa7e0186e25eae5af2096525f99f6f7a376fc86"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a202f286e39636d655384eb055be0f9f27bc67cfb639cf287185ab4d1e84d02c"
    sha256 arm64_sequoia: "efb49df2ab5f460614901a0c11a170a44e7a195076d1e4e225cd057c1c5a3506"
    sha256 arm64_sonoma:  "d43741bd49062e9c4e07b1a3906185f77d838e8dbf91f9ea310dd7326458c361"
    sha256 sonoma:        "a29d7d6dee88d80eabd6cc942983410ff3c7c6e9f79b522325b451ebc152fd90"
    sha256 arm64_linux:   "9fe52e5167712864fa727d1e45bfbcd1a412b8735f5d7e1cf741475383d6b786"
    sha256 x86_64_linux:  "d2b7f1b176007c42ee630d1c3e8780bd18e90bb659f66e81a408061c6ddab1e9"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "jpeg-turbo"
  depends_on "libcbor"
  depends_on "libfido2"
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
  depends_on "uriparser"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "icu4c@78"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
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
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end