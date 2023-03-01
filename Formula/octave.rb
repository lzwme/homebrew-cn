class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  license "GPL-3.0-or-later"
  revision 3

  stable do
    url "https://ftp.gnu.org/gnu/octave/octave-7.3.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/octave/octave-7.3.0.tar.xz"
    sha256 "a508ee6aebccfa68967c9e7e0a08793c4ca8e4ddace723aabdb8f71ad34d57f1"

    # patch to support SuiteSparse 7.0.0 or newer
    # upstream commit ref, https://hg.savannah.gnu.org/hgweb/octave/rev/aaffac4fbe30
    # remove in next release
    patch :DATA
  end

  bottle do
    sha256 arm64_ventura:  "5e3a2ba3770b465bfcbb8884f2edc0bdcd61cef2df1d4b27d0c583a88003dc21"
    sha256 arm64_monterey: "eec6637b967d6d187fb422f309d89419e81e173ed16595ccd5a3d3ef2484e925"
    sha256 arm64_big_sur:  "a65b92d702025ce26455354c6b6a099cd08f9c5fad925b9fb3953c84fcbb2be1"
    sha256 ventura:        "f9355b23a9b858d1a1ccdcbf4ab47803ff0bc27d7baf9a78bce472dc1bc3aebc"
    sha256 monterey:       "02bdc29f8ad12b4a24ac06b2611369fa3c5cf741ba83b03f9183a2d4ad725881"
    sha256 big_sur:        "0619a9a8e7f2f5d94f3dddf3b6d4e7ca607c9a54c1a72c83ecfec121d1d5d67f"
    sha256 x86_64_linux:   "a1a6ad850ca769177f879d97caf08157517a3e58fd674193672554ec0b8d4ed9"
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

__END__
diff --git a/liboctave/util/oct-sparse.h b/liboctave/util/oct-sparse.h
index 088554e..83a6930 100644
--- a/liboctave/util/oct-sparse.h
+++ b/liboctave/util/oct-sparse.h
@@ -89,16 +89,27 @@
 #  include <SuiteSparseQR.hpp>
 #endif

-// Cope with new SuiteSparse versions
+// Cope with API differences between SuiteSparse versions

 #if defined (SUITESPARSE_VERSION)
-#  if (SUITESPARSE_VERSION >= SUITESPARSE_VER_CODE (4, 3))
+#  if (SUITESPARSE_VERSION >= SUITESPARSE_VER_CODE (7, 0))
 #    define SUITESPARSE_NAME(name) SuiteSparse_ ## name
-#    define SUITESPARSE_ASSIGN_FPTR(f_name, f_var, f_assign) (SuiteSparse_config.f_name = f_assign)
-#    define SUITESPARSE_ASSIGN_FPTR2(f_name, f_var, f_assign) (SuiteSparse_config.f_name = SUITESPARSE_NAME (f_assign))
+#    define SUITESPARSE_SET_FCN(name) SuiteSparse_config_ ## name ## _set
+#    define SUITESPARSE_ASSIGN_FPTR(f_name, f_var, f_assign) \
+       SUITESPARSE_SET_FCN(f_name) (f_assign)
+#    define SUITESPARSE_ASSIGN_FPTR2(f_name, f_var, f_assign) \
+       SUITESPARSE_SET_FCN(f_name) (SUITESPARSE_NAME (f_assign))
+#  elif (SUITESPARSE_VERSION >= SUITESPARSE_VER_CODE (4, 3))
+#    define SUITESPARSE_NAME(name) SuiteSparse_ ## name
+#    define SUITESPARSE_ASSIGN_FPTR(f_name, f_var, f_assign) \
+       (SuiteSparse_config.f_name = f_assign)
+#    define SUITESPARSE_ASSIGN_FPTR2(f_name, f_var, f_assign) \
+       (SuiteSparse_config.f_name = SUITESPARSE_NAME (f_assign))
 #  else
-#    define SUITESPARSE_ASSIGN_FPTR(f_name, f_var, f_assign) (f_var = f_assign)
-#    define SUITESPARSE_ASSIGN_FPTR2(f_name, f_var, f_assign) (f_var = CHOLMOD_NAME (f_assign))
+#    define SUITESPARSE_ASSIGN_FPTR(f_name, f_var, f_assign) \
+       (f_var = f_assign)
+#    define SUITESPARSE_ASSIGN_FPTR2(f_name, f_var, f_assign) \
+       (f_var = CHOLMOD_NAME (f_assign))
 #  endif
 #endif