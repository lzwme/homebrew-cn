class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDPreleasesdownload3.14.1freerdp-3.14.1.tar.gz"
  sha256 "2f9a81f8dda223045d3d493790d5d4c2f83edf0afb30eba95da4ce492ed13051"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "2a7869efd065afc268e08fadd99b9ea73e078a108fda24adb7aa2f414dbb767c"
    sha256 arm64_sonoma:  "3ebbfbb697d10c1b9379873996bb24f5b1d0ea8fe782e27c8358997e266b5cb5"
    sha256 arm64_ventura: "7b92d4f2411a1e6983a2a7efc8284195b557b97a8afd77c025776e13c1d3c555"
    sha256 sonoma:        "e22af3edb663bdcecdd44b4b9ace896101d09cf637a799809aa4b4bf9b7611cf"
    sha256 ventura:       "32b3133e39865a63ae4c3a3305a8aaefa6c262f8332d3a6fdcc1683e11b459fd"
    sha256 arm64_linux:   "00b0d8d01c1ebdbaaefd2506d77aefea33f6c9266c7b456a6aaddde749414145"
    sha256 x86_64_linux:  "db32435526f222f50d337b63f43568554213b83801d9f91ed5ef5a163d1f774b"
  end

  head do
    url "https:github.comFreeRDPFreeRDP.git", branch: "master"
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
    # Ref: https:github.comFreeRDPFreeRDPissues10558
    if OS.mac? && MacOS.version >= :sequoia
      # As a workaround, force X11 shadow server implementation. Can use -DWITH_SHADOW=OFF if it doesn't work
      inreplace "servershadowCMakeLists.txt", "add_subdirectory(Mac)", "add_subdirectory(X11)"

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

    success = `#{bin}xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end