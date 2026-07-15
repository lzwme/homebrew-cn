class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://ghfast.top/https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.29.0.tar.gz"
  sha256 "3d08346b81702c1f431c3aef64628df7911f5c9fd49660f6fbea9bc60ff9a82c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "900b15e703a34c44658fb3286adad1760e67433a30d9d750e88a4ed9055a1642"
    sha256 arm64_sequoia: "bfe5d364f8d003b3f2005ed8a8bc031651e6d3d29f075c11d42a794c084b4410"
    sha256 arm64_sonoma:  "ed75b4a942f46e2682d68d1e1ed457ff827f847e05ffb3f32dba553c89a4a83b"
    sha256 sonoma:        "6a7df2f68e89d215c755e17cbe74f4eadbe320018f337a4475cc81958642f7fe"
    sha256 arm64_linux:   "274f5a997e7707b1b419027e2322764d4e3c718b3f0ad286235481869adb1d86"
    sha256 x86_64_linux:  "2f1f831192ecf6ed015b10b01e23fee8771bcae43f832c0a9d7e4f8897f5126c"
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
      -DCHANNEL_RDPEWA=ON
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