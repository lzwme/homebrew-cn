class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://ghfast.top/https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.31.0.tar.gz"
  sha256 "3c66cdd4506b86c451dd0817cb60aa8434c32f56ac1f92aa543f332b376113af"
  license "Apache-2.0"
  head "https://github.com/FreeRDP/FreeRDP.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "e2598bf840910fb814801dae62465514392ca3c958bac7b0eff8b2e1a7976f39"
    sha256 arm64_sequoia: "3f8a076a3289bd4ee45e4dd303757957d459bd10ee67682c07ebfc1bef120709"
    sha256 arm64_sonoma:  "acc6f440de1fdbbff6b0fc258bbd153faf5b90769f6f97f8eba0027628c8b649"
    sha256 sonoma:        "ccfbf34e9364298dc0d4c304eb471c38e1dbadb5d94bad41e93b141b012f4317"
    sha256 arm64_linux:   "a621c3d028cf0fe661f0a342371630b9268034493e4a22ca3f5e2194dcb35029"
    sha256 x86_64_linux:  "c119d9b87083cf60c02e8e656fb562b87c94a3c931daff02168d865ea9cc4d1d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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