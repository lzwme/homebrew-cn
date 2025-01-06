class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44/ngspice-44.tar.gz"
  sha256 "3865d13ab44f1f01f68c7ac0e0716984e45dce5a86d126603c26d8df30161e9b"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "4065a95b82cd0068743ab9c2ddfeeaa0fcbb17f6fe80bd8e06a69ed63959243d"
    sha256 arm64_sonoma:  "16cd3c95576f9a01a8d959a9ebf739fd2ba66d19d64fd573b135f1e58bbb57ae"
    sha256 arm64_ventura: "0a95925e6f1851e96d36e5a3011f65b724f11dec96ebf852c84a5253bf980bee"
    sha256 sonoma:        "a092da5427590a00c6037df644c7624c69d93894dafd78d6b1e918ddd802011a"
    sha256 ventura:       "5231f6839262cfa786e058ec34df2c008971abbbeb5c9298fd762f764f780369"
    sha256 x86_64_linux:  "08f6e7e51b425b129347542106eb86d3024f3492eb0bbdc87ad3edf77e9757d4"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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