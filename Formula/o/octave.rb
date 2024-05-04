class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-9.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-9.1.0.tar.xz"
  sha256 "ed654b024aea56c44b26f131d31febc58b7cf6a82fad9f0b0bf6e3e9aa1a134b"
  license "GPL-3.0-or-later"
  revision 2

  # New tarballs appear on https://ftp.gnu.org/gnu/octave/ before a release is
  # announced, so we check the octave.org download page instead.
  livecheck do
    url "https://octave.org/download"
    regex(%r{Octave\s+v?(\d+(?:\.\d+)+)(?:\s*</[^>]+?>)?\s+is\s+the\s+latest\s+stable\s+release}im)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "39facd51c0a174ceaf405e1aeb12c7c5641a1b301bf8a0f5192b3fc0c38aa607"
    sha256 arm64_ventura:  "06c2ecc966bc16396bcaae07844e71b31341116e43ca6ec787d734c54d993e84"
    sha256 arm64_monterey: "83acb517f85d91e02a952f029702ddc229705808ce739a94a4ab9e0a38ae2ae8"
    sha256 sonoma:         "cb700a5a45776641355cf5118573f31d0675c77daa23a26a89c8260773c01986"
    sha256 ventura:        "8ba1c839a0fc9c2db22df8a8e70a83950aa047236d11c1f7b8c4d225412ac6ae"
    sha256 monterey:       "2c961099217bad63bb4fea2c8c3cd201b8fed86d1b6783da1653e6be56f077c1"
    sha256 x86_64_linux:   "6fbeea0d955161430848f860c4ec826d341b2d0b6d0c452453bfaf54d23b202c"
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", branch: "default", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "autoconf" => :build # for the patches
  depends_on "automake" => :build # for the patches
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "libtool" => :build # for the patches
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fig2dev"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "ghostscript"
  depends_on "gl2ps"
  depends_on "glpk"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "qscintilla2"
  depends_on "qt"
  depends_on "rapidjson"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"

  uses_from_macos "curl"

  on_linux do
    depends_on "autoconf"
    depends_on "automake"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  fails_with gcc: "5"

  # Fix build for Qt 6.7.0
  # https://hg.savannah.gnu.org/hgweb/octave/rev/f428a432ed4f
  patch do
    url "https://hg.savannah.gnu.org/hgweb/octave/raw-rev/f428a432ed4f"
    sha256 "a9dd08ffecff5b310039b14847e8012e150de9b71337adc0955b0e668eea1d37"
  end

  # Fix opengl-partial-update bug causing crashes on figure() and plot() with Qt 6.7.0
  # https://hg.savannah.gnu.org/hgweb/octave/rev/317fa0e5c8de
  patch do
    url "https://hg.savannah.gnu.org/hgweb/octave/raw-rev/317fa0e5c8de"
    sha256 "909dc65614d0ef2520c35c5f8d4f78c451b189b2673e837f4f21c18a776273f0"
  end

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc",
              /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/,
              '""'

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["qt"].opt_libexec/"lib/pkgconfig" if OS.mac?

    system "./bootstrap" if build.head?
    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--disable-static",
      "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
      "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
      "--with-java-homedir=#{Formula["openjdk"].opt_prefix}",
      "--with-x=no",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-portaudio",
      "--with-sndfile",
    ]

    if OS.linux?
      # Explicitly specify aclocal and automake without versions
      args << "ACLOCAL=aclocal"
      args << "AUTOMAKE=automake"

      # Mesa OpenGL location must be supplied by LDFLAGS on Linux
      args << "LDFLAGS=-L#{Formula["mesa"].opt_lib} -L#{Formula["mesa-glu"].opt_lib}"

      # Docs building is broken on Linux
      args << "--disable-docs"

      # Need to regenerate aclocal.m4 so that it will work with brewed automake
      system "aclocal"
    end

    system "./configure", *args, *std_configure_args
    system "make", "all"

    # Avoid revision bumps whenever fftw's, gcc's or OpenBLAS' Cellar paths change
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath/"scripts/startup/site-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{Formula["texinfo"].opt_bin}/makeinfo\");"

    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with BLAS
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test basic compilation
    (testpath/"oct_demo.cc").write <<~EOS
      #include <octave/oct.h>
      DEFUN_DLD (oct_demo, args, /*nargout*/, "doc str")
      { return ovl (42); }
    EOS
    system bin/"octave", "--eval", <<~EOS
      mkoctfile ('-v', '-std=c++11', '-L#{lib}/octave/#{version}', 'oct_demo.cc');
      assert(oct_demo, 42)
    EOS
    # Test FLIBS environment variable
    system bin/"octave", "--eval", <<~EOS
      args = strsplit (mkoctfile ('-p', 'FLIBS'));
      args = args(~cellfun('isempty', args));
      mkoctfile ('-v', '-std=c++11', '-L#{lib}/octave/#{version}', args{:}, 'oct_demo.cc');
      assert(oct_demo, 42)
    EOS
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system bin/"octave", "--gui"
  end
end