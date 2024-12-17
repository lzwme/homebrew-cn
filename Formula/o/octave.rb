class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https:octave.orgindex.html"
  url "https:ftp.gnu.orggnuoctaveoctave-9.3.0.tar.xz"
  mirror "https:ftpmirror.gnu.orgoctaveoctave-9.3.0.tar.xz"
  sha256 "712468513db7e13b76f28c4b82cdba7d6f3f634c836ddb27a7a8fe9d708145f3"
  license "GPL-3.0-or-later"

  # New tarballs appear on https:ftp.gnu.orggnuoctave before a release is
  # announced, so we check the octave.org download page instead.
  livecheck do
    url "https:octave.orgdownload"
    regex(%r{Octave\s+v?(\d+(?:\.\d+)+)(?:\s*<[^>]+?>)?\s+is\s+the\s+latest\s+stable\s+release}im)
  end

  bottle do
    sha256 arm64_sonoma:  "cbbe2445ed0a7370a45e5f941ab10a5e3b27e51fc1ba251ab9f1c092cdcb75cd"
    sha256 arm64_ventura: "f18386f288b6e728795c020fb5967ac8007da8465bb51ac420da3fd34f6da578"
    sha256 sonoma:        "843daa96cfc9a4fcaaf84850e3e631230e3f6562d2e3896c6b96b9c167f3efef"
    sha256 ventura:       "fa951433d5b072ed76d982139189b93f27aba69c19e58e2e29460e2dfd04ddf8"
    sha256 x86_64_linux:  "cdcaffa0641206c7d35a3cebcd2a81a6e92b1289146cc81aaf363bb2058c1a47"
  end

  head do
    url "https:hg.savannah.gnu.orghgweboctave", branch: "default", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https:wiki.octave.orgBuilding
  depends_on "gnu-sed" => :build # https:lists.gnu.orgarchivehtmloctave-maintainers2016-09msg00193.html
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
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

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "autoconf"
    depends_on "automake"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every octmex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "srcmkoctfile.in.cc",
              %OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%,
              '""'

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["qt"].opt_libexec"libpkgconfig" if OS.mac?

    system ".bootstrap" if build.head?
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

    system ".configure", *args, *std_configure_args
    # https:github.comHomebrewhomebrew-corepull170959#issuecomment-2351023470
    ENV.deparallelize do
      system "make", "all"
    end

    # Avoid revision bumps whenever fftw's, gcc's or OpenBLAS' Cellar paths change
    inreplace "srcmkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath"scriptsstartupsite-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{Formula["texinfo"].opt_bin}makeinfo\");"

    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin"octave", "--eval", "(227 - pi)pi"
    # This is supposed to crash octave if there is a problem with BLAS
    system bin"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test basic compilation
    (testpath"oct_demo.cc").write <<~CPP
      #include <octaveoct.h>
      DEFUN_DLD (oct_demo, args, *nargout*, "doc str")
      { return ovl (42); }
    CPP
    system bin"octave", "--eval", <<~MATLAB
      mkoctfile ('-v', '-std=c++11', '-L#{lib}octave#{version}', 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB
    # Test FLIBS environment variable
    system bin"octave", "--eval", <<~MATLAB
      args = strsplit (mkoctfile ('-p', 'FLIBS'));
      args = args(~cellfun('isempty', args));
      mkoctfile ('-v', '-std=c++11', '-L#{lib}octave#{version}', args{:}, 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system bin"octave", "--gui"
  end
end