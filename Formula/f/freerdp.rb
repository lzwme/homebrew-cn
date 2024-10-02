class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https:www.freerdp.com"
  url "https:github.comFreeRDPFreeRDParchiverefstags3.8.0.tar.gz"
  sha256 "e313934a77a0bcca3af803455dd9ea1aa2f657c598e3397325aa48e6effd450d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "84cb696ab17abfb46794ab5d42371016ff302e3a0022728280cd2181ce2c8bb8"
    sha256 arm64_sonoma:  "3098a9f2292dedf9b8dec36137550d4dc23cc51615714d3b0af799bda88fb06b"
    sha256 arm64_ventura: "ef480c11de85c450b3898ff8b9e91b7477c479e575bc87fe5d9f2858868b3fb3"
    sha256 sonoma:        "de1725f02fdef73888ec632e5054788f70ab322a5e500f900237251148abf346"
    sha256 ventura:       "63d1d5237810b6fc0da43d5092ce310f9c9556bb610053655eb08f81052a2d30"
    sha256 x86_64_linux:  "0efc0062285eb3ea99ed8359558340b4d8d804c9dff6fbd51ce25bd5b9144dce"
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
  depends_on "sdl2"
  depends_on "sdl2_ttf"

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
    ENV.append_to_cflags "-I#{Formula["sdl2_ttf"].opt_include}SDL2"

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_X11=ON
      -DWITH_JPEG=ON
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=ON
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