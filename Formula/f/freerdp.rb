class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDParchiverefstags3.8.0.tar.gz"
  sha256 "e313934a77a0bcca3af803455dd9ea1aa2f657c598e3397325aa48e6effd450d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "ab64c73394aae736fdf575a169283b260db94726ecbe5921df314b40c0abff0b"
    sha256 arm64_ventura:  "6e3001bdf3d9ba1b0f4aeff85d5de61788b783d3caa1966b5614017bb5226a4c"
    sha256 arm64_monterey: "0a0d69d918188f2c83be63fb9fd24709b04c250510acff2c01b1975a4c49718f"
    sha256 sonoma:         "fd7cc10c98ae3ff4c651108025c4ed7ea92982e9938a583dae56d1b139deb996"
    sha256 ventura:        "85553e50f0512985443267b36a78f584d1afab0fbdeca1cebf0177e90fa5ea67"
    sha256 monterey:       "b27c7d522042220ff01e3889d1f0f2984d986ec1b336ef7596142b02dfacd57c"
    sha256 x86_64_linux:   "5a123ca4fbf5981e4e86cf2a488464d70739c0940960f222bf3b34a47270c42d"
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

  # fix type conversion issue with `_Unwind_GetLanguageSpecificData`, upstream pr ref, https:github.comFreeRDPFreeRDPpull10542
  patch do
    url "https:github.comFreeRDPFreeRDPcommit06d8164d5669c02759894d024f285e028c2023de.patch?full_index=1"
    sha256 "484407240002837cf9a32c6f1250c040710cdf1b78f8455565dca936c078d6c5"
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