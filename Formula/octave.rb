class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-8.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-8.2.0.tar.xz"
  sha256 "b7b9d6e5004ff039450cfedd2a59ddbe2a3c22296df927a8af994182eb2670de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "94f76da6ebc5a5142e2948da10746bd68e590b867b16c22b748cf1d1540574c1"
    sha256 arm64_monterey: "978ec7da12cecead8b0f815de6e9e4cac02dfa643be124ca85cf53d17f09c53f"
    sha256 arm64_big_sur:  "3071bf7637ea50a1aca6e402179671aa80789b92e20cf9cac1a408af1e28e583"
    sha256 ventura:        "518130db9e73de1ab117fd84821ddd969ed753d98bd4ac1278a34b52e68077c9"
    sha256 monterey:       "9672ac6e80d7b06fffcfc93f36a7f97d0b06439cb7276ce4b67e186069bf54c7"
    sha256 big_sur:        "aa9141bf1b6fd68035f94ac6d39b8f1a20a2bc752e1bed892156c8022f17e79b"
    sha256 x86_64_linux:   "9e6d41ade9fe6964e3f19a48b412736036da3a718e33509364e1cda979daa4af"
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
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
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
  depends_on "gnuplot"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "openblas"
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "qscintilla2"
  depends_on "qt@5"
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

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc",
              /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/,
              '""'

    # SUNDIALS 6.4.0 and later needs C++14 for C++ based features
    # Configure to use gnu++14 instead of c++14 as octave uses GNU extensions
    ENV.append "CXX", "-std=gnu++14"

    # Qt 5.12 compatibility
    # https://savannah.gnu.org/bugs/?55187
    ENV["QCOLLECTIONGENERATOR"] = "qhelpgenerator"
    # These "shouldn't" be necessary, but the build breaks without them.
    # https://savannah.gnu.org/bugs/?55883
    ENV["QT_CPPFLAGS"]="-I#{Formula["qt@5"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["qt@5"].opt_include}"
    ENV["QT_LDFLAGS"]="-F#{Formula["qt@5"].opt_lib}"
    ENV.append "LDFLAGS", "-F#{Formula["qt@5"].opt_lib}"

    system "./bootstrap" if build.head?
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-shared",
            "--disable-static",
            "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
            "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
            "--with-java-homedir=#{Formula["openjdk"].opt_prefix}",
            "--with-x=no",
            "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
            "--with-portaudio",
            "--with-sndfile"]

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

    system "./configure", *args
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
  end
end