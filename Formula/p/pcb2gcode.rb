class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://ghfast.top/https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "463c53e2102aac0be002b092b508751d20b7ba1da057f41470585ccbdb6e8a79"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bbc11859080838a33d817b7e21424967a7f074315b7da188d68a54f2842d6f3"
    sha256 cellar: :any,                 arm64_sequoia: "d87848faa361ecf2e7660fdaf47745210bd14cf8072d6ed705c9c400c06e5527"
    sha256 cellar: :any,                 arm64_sonoma:  "e0f2825e6e17348367b467aef23e0fba4263063cbe3bb7493a1fa1825c013b80"
    sha256 cellar: :any,                 sonoma:        "c280beaa3eb3c108e6829dd4e6f2094a121b036c633066442ec60c076caede3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b0c539746bdebdb7c71a7d2566b2fe97aeeded50e61759c612adc9c0a48e056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27c42ab6fddb5e48d644d35c64a6d97d9fde47b584f9cd8caec3acc3af04032"
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