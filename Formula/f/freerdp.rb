class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDParchiverefstags3.4.0.tar.gz"
  sha256 "0fe77b2b838f32598a11c63ff4a1c0482d5bac0da7753ce6446039349ed96b00"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "7f47ee773462c02b58529e04104393b9b8034fe7c4bf6c135b94821bcb4ae3a8"
    sha256 arm64_ventura:  "f3f0940d002b34aaea55db776419691b9dffe8a457f530dab5563965706f578b"
    sha256 arm64_monterey: "61c56c1ad9b23b6f6c8b670707705d5470aab873def7af618b24bfe6eb8fb28b"
    sha256 sonoma:         "c0e94b8d1a1ba9522c8d4df57c4682830810f754c4cebd29b27c440d0e4ac871"
    sha256 ventura:        "8757c9a143d563942b1671b1fe3ebd83da9a29375f3eeea6a31057b7ae1a9dfc"
    sha256 monterey:       "8eda65163bf56433c0021c289848d0bb414bc503d5bcfd16397c3ada2c89b937"
    sha256 x86_64_linux:   "16b3c35d2d7007a3c750631907a91647cd67444ae2bac4099ed150079fa038d6"
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

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
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