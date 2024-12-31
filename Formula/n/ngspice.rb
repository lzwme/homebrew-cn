class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44/ngspice-44.tar.gz"
  sha256 "8fef0e80b324df1f6ac6c73a9ed9a4120a9a17b62c13e83e1f674a9d9e6a4142"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "3137db5e486825253c5189af8a360ccba86b51a1f43bcb4bd20903d0558d52d9"
    sha256 arm64_sonoma:  "bfaa71b5943132e959147136b50c81295aa949d4be3e6e455b15680ee6f380ba"
    sha256 arm64_ventura: "ae6abd74200c1b1efa83d64c0d2908b30b3cf90836b8f40367c7fdb4b457d9c8"
    sha256 sonoma:        "3957caa308e93b869cdbdff5d68b88356a1bc5da4e97dce03901037e9b9005c9"
    sha256 ventura:       "ca0b4853b3efd4df944b12fcd24b5254786e6312fc589c5b0cea0944f58817c8"
    sha256 x86_64_linux:  "7a233aef2813b9f45d2d1234f7292c35073299762f6b11f0e047f64fae8fba71"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "fftw"
  depends_on "freetype"
  depends_on "libngspice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxext"
    depends_on "libxmu"
  end

  def install
    # upstream bug report on the `configure` script, https://sourceforge.net/p/ngspice/bugs/731/
    system "./autogen.sh"

    # Xft #includes <ft2build.h>, not <freetype2/ft2build.h>, hence freetype2
    # must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    args = %w[
      --enable-cider
      --enable-xspice
      --disable-openmp
      --enable-pss
      --with-readline=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_r(Dir[lib/"ngspice"])
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system bin/"ngspice", "test.cir"
  end
end