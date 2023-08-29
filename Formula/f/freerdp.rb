class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  # TODO: Check if this can use unversioned ffmpeg at version bump.
  url "https://ghproxy.com/https://github.com/FreeRDP/FreeRDP/archive/2.11.0.tar.gz"
  sha256 "ccc342d4616c89323c355704d47ab45f6a770559cfff1b3965356d2313d3c3cc"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "58f70b2c20926cfffa567da87c1d4c0baf9b8e4138b1677775057ebcf14d952a"
    sha256                               arm64_monterey: "4fdea2e8fac15fc8f60ac7f7384a35a34680b09e5ba3e9517ff14f499b694552"
    sha256                               arm64_big_sur:  "a7e9c773895d40954961984a29fbb806876eaeefa5a6c73d35ff511e9496b942"
    sha256                               ventura:        "c21b21ee90a014211c9f325c737d4a0c4df8d1b730057f7a97cffcef74f15b53"
    sha256                               monterey:       "ae3fbaa139d41d40369b8549f512b95b865004bca2c53985c984ef95a410c2b4"
    sha256                               big_sur:        "cf1512f13f78f65a1f25fbf8f48294b862da662d9415cf65077d5983bbe70bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b298a8df407472e13b170e8e46ed10bbe24e7d324695ec4f945cdb85c799b840"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg@4"
    depends_on "glib"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DWITH_X11=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DWITH_JPEG=ON",
                    "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
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

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end