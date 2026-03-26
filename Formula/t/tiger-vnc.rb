class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://ghfast.top/https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "d00fb52d9863e6bcbef9d6fb8a92170f6e1400114b13dd0efccc0ed0246f6d70"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8212172125cfaaa001c1badebb4a4d3cc96e23900bdf539679321af010911df1"
    sha256 cellar: :any, arm64_sequoia: "c7640efb35d5c155bbdb8d32475e8932ee6bbed628e30e6413cc4676e4ea77b8"
    sha256 cellar: :any, arm64_sonoma:  "49d7dc5a2a69d2f15192eaf54332916c0d2f8b9cd427f049a1c5831865ce36e4"
    sha256 cellar: :any, sonoma:        "a5a76ea5fd32a362feb730860b2446a702b2f952a3b189f87565047c98c9c683"
    sha256               arm64_linux:   "f25220fcc997aefeeed774cda23847abf7eee047932a627b55e582233efcc6f5"
    sha256               x86_64_linux:  "ef4fcb8ceaec65b3501d874e4611e4ca3340ba4204025275863eed0dca72b158"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  on_macos do
    depends_on "gettext"
  end

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
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match(/TigerVNC v#{version}/, output)
  end
end