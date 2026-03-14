class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://ghfast.top/https://github.com/FreeRDP/FreeRDP/releases/download/3.24.0/freerdp-3.24.0.tar.gz"
  sha256 "168011bd58eae8d898842ef39c6c9bf5761ab617a68ccad80d623a3e535d0367"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "9a166c23ed9a4ad676d740e4e52cb46fa794e77160995e62868a86e3ab9df30a"
    sha256 arm64_sequoia: "c8dafb554aff4b668f90111e35aa3970f3e86ca6e137a99d43d68aa165e5ef41"
    sha256 arm64_sonoma:  "a3ff957931234ee35ed031208731438bbb5886452bc155ca165c739ba826e2e0"
    sha256 sonoma:        "543b50d37790b4d2af8fd8081d3301ad6d18228fa7f3aae7f9bf9aceb68774af"
    sha256 arm64_linux:   "dc4a9eb7028cc3ecb797f2f08d3d41cc27d0307bf1ec7863e3c2de1da1ec15e2"
    sha256 x86_64_linux:  "f45bac69ed6488b8ad2edc34c6584a309bde570f18798a7210594b58bda06f27"
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