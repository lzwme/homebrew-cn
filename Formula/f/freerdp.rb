class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDParchiverefstags3.6.3.tar.gz"
  sha256 "5c8b430ff20d0e367d4774248d52dc2d0feeb2b27af82feecfec0c702b41ab76"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "59a8a5fa6d5af54e62e141ca76ce1f08f69dadd64f65bf449629b5577dbff66d"
    sha256 arm64_ventura:  "b60c2d5051e043638f774f6b56bbf6fbc5e4316e2d95cffb989a4003533d6fd0"
    sha256 arm64_monterey: "faeebab6227b8280cc36965f3b61ce4556354c0ba45a4f76fd460ee3f6442ff2"
    sha256 sonoma:         "9d4b887479e1ec48cb5e3645f3875a2c3beb614a1b419c5425b0f0e10f495721"
    sha256 ventura:        "2754f4d1e3e15555f24d3206e133afce5b1719e1882a5058169badb6701edfd6"
    sha256 monterey:       "fe8a1b6f6d493b2a7b2c5d50ae2c19bd914060cd1ce026a74baba7f5883e5293"
    sha256 x86_64_linux:   "2d740a9cdba1b8ba8a8d8131f83bc0b7a9165b16d91cf22192214f0b00016980"
  end

  head do
    url "https:github.comFreeRDPFreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "icu4c"
    depends_on "krb5"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %W[
      -DWITH_X11=ON
      -DBUILD_SHARED_LIBS=ON
      -DWITH_JPEG=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=OFF
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end