class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https:tigervnc.org"
  url "https:github.comTigerVNCtigervncarchiverefstagsv1.14.1.tar.gz"
  sha256 "579d0d04eb5b806d240e99a3c756b38936859e6f7db2f4af0d5656cc9a989d7c"
  license "GPL-2.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 1.9.90 tag is used for the
  # 1.10.0 beta release) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "160d047fc18c4f0d6e3248b891af26eedaadb399dfbab8cdfa22fd38381da2a5"
    sha256 cellar: :any, arm64_sonoma:  "394baefd26256c2a60d8473df54c3dcd2f9fd622390978bc42f66b167e61754b"
    sha256 cellar: :any, arm64_ventura: "e3dc4bd4028728591444dff08dcefa89bd2feccd8809e87b113acd308e84e291"
    sha256 cellar: :any, sonoma:        "8a72bcc982e92fb1df9425096f1e2ee7a3482518d0c51f1b52026dcd900fb7e9"
    sha256 cellar: :any, ventura:       "75049c896f1ca55cf17c9dddb35ddc8b2145387cd6584808da08ae20b1c2cd37"
    sha256               x86_64_linux:  "f2d19f4ff08c3bdbd5564ac5fe95d86efd2262c67b806411fc79e8860c87ea4e"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "linux-pam"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}#{shared_library("libjpeg")}
      .
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}vncviewer -h 2>&1", 1)
    assert_match "TigerVNC Viewer v#{version}", output
  end
end