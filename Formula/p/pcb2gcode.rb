class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https:github.compcb2gcodepcb2gcode"
  url "https:github.compcb2gcodepcb2gcodearchiverefstagsv2.5.0.tar.gz"
  sha256 "96f1b1b4fd58e86f152b691202a15593815949dc9250fab9ab02f2346f5c2c52"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.compcb2gcodepcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27ed86df9a677b86d0f3b5da18174f4bae523b83194eb2a823c00df5eae5e598"
    sha256 cellar: :any,                 arm64_ventura:  "7ae936306e87c7a2f53bb0a9b178dfb8fa5db8fb85120553b2cfa0167a9583c2"
    sha256 cellar: :any,                 arm64_monterey: "adf83b9e81bc4365daba6683f49fca7a34be8eb17e9fe194944134a05b07e37a"
    sha256 cellar: :any,                 sonoma:         "1aaeb26437220ca3b1e23fab234a1a207dd1c2986d6a0b756e5bce9a27957813"
    sha256 cellar: :any,                 ventura:        "ec0216c497ec9f81f9b6d2896b0f2a7961b9bb730a7202c2367003efee8a1cff"
    sha256 cellar: :any,                 monterey:       "39fa779c59ff7f2559137e5140b4f82d5cf70df44da690b564f2cc7071bab23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d622e3292f5c3a7ba71def4dcd7c27a19cde4f0a17b47a8e7a4604b7d502a92"
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
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath"front.gbr").write <<~EOS
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
    (testpath"edge.gbr").write <<~EOS
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
    (testpath"drill.drl").write <<~EOS
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
    (testpath"millproject").write <<~EOS
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
    system bin"pcb2gcode", "--front=front.gbr",
                               "--outline=edge.gbr",
                               "--drill=drill.drl"
  end
end