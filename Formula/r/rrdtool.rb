class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  url "https://ghfast.top/https://github.com/oetiker/rrdtool-1.x/releases/download/v1.10.2/rrdtool-1.10.2.tar.gz"
  sha256 "9787114551ee9b5db7c72722736388dcc54bf00ded51b5dd47feed11fb179fe4"
  license "GPL-2.0-or-later" => { with: "RRDtool-FLOSS-exception-2.0" }

  bottle do
    sha256 arm64_tahoe:   "051f5d703153edee574abad317a3e7d03be526ef712a7212f3e1587980159e04"
    sha256 arm64_sequoia: "b89b7f551c094b9f3ed7eaabb59d15fa8ebc7aa69a06862a02f9abb8773a2035"
    sha256 arm64_sonoma:  "0f36a8248b6bd147ba3601be87bdb3a3de69310e266025fc9b6b2b2a057d5eaf"
    sha256 sonoma:        "1cff00acce82e849f5ae6ee16b76b8af0f95187dd72bbefe383e65a2de624097"
    sha256 arm64_linux:   "5cef6094c0e589e198d2c5246d84a29819a66812c0ec98e51c2472782e9635d8"
    sha256 x86_64_linux:  "f4fe866543a042fde8de3d4c70d3ac8b4f7125eb878269555657a0b1540bffff"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libpng"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    args = %w[
      --disable-silent-rules
      --disable-lua
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-tcl
    ]

    system "./bootstrap" if build.head?
    inreplace "configure", /^sleep 1$/, "#sleep 1"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"

    system bin/"rrdtool", "dump", "temperature.rrd"
  end
end