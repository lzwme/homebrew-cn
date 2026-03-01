class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://ghfast.top/https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d39b713c432e9536d075caa5e11065f73b5894a6907645bcd08a0e60ef740e06"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09418fbb8655886d52a1150f0d33d1c73c3ab7e4bb95b8ae708cf420fb17cc1b"
    sha256 cellar: :any,                 arm64_sequoia: "d24764d5577c95188e266dc534fd622936aae7836c9da34b415b95d2f6e4f229"
    sha256 cellar: :any,                 arm64_sonoma:  "f052802b280466e8d93afe75a1424ee95b3d1dc8cb74946d314ce5b5956ab4d2"
    sha256 cellar: :any,                 sonoma:        "e32f2ac93824f32ce8fa039f62558ec45a8368e384d73a9dd39ca59f370632ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5b89e0fa97b5258a00e06dc216997b7e367c91850d0ffefa3666b3541f6100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b7470df5a463a3dc9ca4ac3cbf518d4e859ecbd227749ba4ea553d130390e2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairomm@1.14" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libtool" => :build
  depends_on "pangomm@2.46" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "boost"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gerbv"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "harfbuzz"
  depends_on "pango"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"front.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11R,2.032000X2.032000*%
      %ADD12O,2.032000X2.032000*%
      %ADD13C,0.250000*%
      D11*
      X127000000Y-63500000D03*
      D12*
      X127000000Y-66040000D03*
      D13*
      X124460000Y-66040000D01*
      X124460000Y-63500000D01*
      X127000000Y-63500000D01*
      M02*
    EOS
    (testpath/"edge.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11C,0.150000*%
      D11*
      X123190000Y-67310000D02*
      X128270000Y-67310000D01*
      X128270000Y-62230000D01*
      X123190000Y-62230000D01*
      X123190000Y-67310000D01*
      M02*
    EOS
    (testpath/"drill.drl").write <<~EOS
      M48
      FMAT,2
      METRIC,TZ
      T1C1.016
      %
      G90
      G05
      M71
      T1
      X127.Y-63.5
      X127.Y-66.04
      T0
      M30
    EOS
    (testpath/"millproject").write <<~EOS
      metric=true
      zchange=10
      zsafe=5
      mill-feed=600
      mill-speed=10000
      offset=0.1
      zwork=-0.05
      drill-feed=1000
      drill-speed=10000
      zdrill=-2.5
      bridges=0.5
      bridgesnum=4
      cut-feed=600
      cut-infeed=10
      cut-speed=10000
      cutter-diameter=3
      fill-outline=true
      zbridges=-0.6
      zcut=-2.5
      al-front=true
      al-probefeed=100
      al-x=15
      al-y=15
      software=LinuxCNC
    EOS
    system bin/"pcb2gcode", "--front=front.gbr",
                            "--outline=edge.gbr",
                            "--drill=drill.drl"
  end
end