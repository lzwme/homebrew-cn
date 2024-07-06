class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDParchiverefstags3.6.2.tar.gz"
  sha256 "e16260946a1d3289339bf158f335d9dddd9af43b96050b6b6fba287310df9924"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "9a465e1ffb7b7f070b615e117987a976196b2f05e534b6c489c755794fac07b1"
    sha256 arm64_ventura:  "0a89a05f181e0d88e25a6319bb04c550ecae71f5dd21dff78659212bd21f89c3"
    sha256 arm64_monterey: "f1bcc10a20e3939b80fe7f23a82b997b05767f1e8fcd8df5d28063cb7aa25708"
    sha256 sonoma:         "d1af3dc51ba5a621818bb21a2025eb474a98dde458187466b9056e63631b1df1"
    sha256 ventura:        "2919a408ea6ceb7246237d3dc163cdec91ab093783f0071690c2bf895b931c46"
    sha256 monterey:       "ee4be641f12660a853548e9c9619e8d238ad9fee4a0da3a36c569cd9505e08d6"
    sha256 x86_64_linux:   "1e1dbc0c569202b1e892b745559912bf8971747f50dfd3f5fb658105f6a4f589"
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