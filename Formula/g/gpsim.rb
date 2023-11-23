class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.32.0/gpsim-0.32.1.tar.gz"
  sha256 "c704d923ae771fabb7f63775a564dfefd7018a79c914671c4477854420b32e69"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpsim[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma: "fa23f8c80ac0345a2f22b8ea0ba306c915947df7eac7ace8cbd14e1eff4a6b9c"
    sha256 cellar: :any,                 sonoma:       "2981d50ca8314999f1aed8b224da83e52b74d013fc6dd3c5ff9d14fa98fe482c"
    sha256 cellar: :any,                 monterey:     "82ed0708bc543e6a067d5b23647de05de60c2abf4c4851adcb9c7f58d2f60b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ed7b77aad09ad8845ef7b7f7481c8d480e65f69eb92715b0045d9c8d80ac5c27"
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-gui",
                          "--disable-shared",
                          *std_configure_args
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end