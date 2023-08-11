class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-8.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-8.2.0.tar.xz"
  sha256 "b7b9d6e5004ff039450cfedd2a59ddbe2a3c22296df927a8af994182eb2670de"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 arm64_ventura:  "fe76f0522e7e27d06858e45f860cd501043903205a90321761e9f7688b90ff73"
    sha256 arm64_monterey: "0b395ddabeff0cc6112efae65de139ab91832693907ca6e823b213628f7d7459"
    sha256 arm64_big_sur:  "a205ef7b83d729e983ccd4a77909b3d72c453584e1f90ba2b6b91463cea09559"
    sha256 ventura:        "9045e38fc6c6bc93c62e375f863a57690e378debbbf97b6ac4f0a79bbe0ae2da"
    sha256 monterey:       "15149ce822a08e9e919ff0760da8f6be099982fc16d5575472e973cc93e5356f"
    sha256 big_sur:        "2cc855ab87a2c6f85b0096e4c1fb20ba75b4ef9b9f5ca59e73cb5b1484bfa8ae"
    sha256 x86_64_linux:   "c9bb830ca7832e8e120121c6bd2c0f2308eae8f6dd36151fba1da5be3300088d"
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

  # Upstream fix for compatibility with SuiteSparse 7.1.0
  # http://hg.savannah.gnu.org/hgweb/octave/rev/134152cf1a3f
  patch :DATA

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
diff --git a/liboctave/numeric/sparse-qr.cc b/liboctave/numeric/sparse-qr.cc
--- a/liboctave/numeric/sparse-qr.cc
+++ b/liboctave/numeric/sparse-qr.cc
@@ -805,16 +805,17 @@
   cholmod_dense *q;

   // I is nrows x nrows identity matrix
-  cholmod_dense *I
+  cholmod_dense *I_mat
     = cholmod_l_allocate_dense (nrows, nrows, nrows, CHOLMOD_REAL, &m_cc);

   for (octave_idx_type i = 0; i < nrows * nrows; i++)
-    (reinterpret_cast<double *> (I->x))[i] = 0.0;
+    (reinterpret_cast<double *> (I_mat->x))[i] = 0.0;

   for (octave_idx_type i = 0; i < nrows; i++)
-    (reinterpret_cast<double *> (I->x))[i * nrows + i] = 1.0;
-
-  q = SuiteSparseQR_qmult<double> (SPQR_QX, m_H, m_Htau, m_HPinv, I, &m_cc);
+    (reinterpret_cast<double *> (I_mat->x))[i * nrows + i] = 1.0;
+
+  q = SuiteSparseQR_qmult<double> (SPQR_QX, m_H, m_Htau, m_HPinv, I_mat,
+                                   &m_cc);
   spqr_error_handler (&m_cc);

   double *q_x = reinterpret_cast<double *> (q->x);
@@ -824,7 +825,7 @@
       ret_vec[j * nrows + i] = q_x[j * nrows + i];

   cholmod_l_free_dense (&q, &m_cc);
-  cholmod_l_free_dense (&I, &m_cc);
+  cholmod_l_free_dense (&I_mat, &m_cc);

   return ret;

@@ -1739,17 +1740,17 @@
   cholmod_dense *q;

   // I is nrows x nrows identity matrix
-  cholmod_dense *I
+  cholmod_dense *I_mat
     = reinterpret_cast<cholmod_dense *>
       (cholmod_l_allocate_dense (nrows, nrows, nrows, CHOLMOD_COMPLEX, &m_cc));

   for (octave_idx_type i = 0; i < nrows * nrows; i++)
-    (reinterpret_cast<Complex *> (I->x))[i] = 0.0;
+    (reinterpret_cast<Complex *> (I_mat->x))[i] = 0.0;

   for (octave_idx_type i = 0; i < nrows; i++)
-    (reinterpret_cast<Complex *> (I->x))[i * nrows + i] = 1.0;
-
-  q = SuiteSparseQR_qmult<Complex> (SPQR_QX, m_H, m_Htau, m_HPinv, I,
+    (reinterpret_cast<Complex *> (I_mat->x))[i * nrows + i] = 1.0;
+
+  q = SuiteSparseQR_qmult<Complex> (SPQR_QX, m_H, m_Htau, m_HPinv, I_mat,
                                     &m_cc);
   spqr_error_handler (&m_cc);

@@ -1761,7 +1762,7 @@
       ret_vec[j * nrows + i] = q_x[j * nrows + i];

   cholmod_l_free_dense (&q, &m_cc);
-  cholmod_l_free_dense (&I, &m_cc);
+  cholmod_l_free_dense (&I_mat, &m_cc);

   return ret;

@@ -2073,7 +2074,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < S->m2; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_ipvec) (S->pinv,
                                reinterpret_cast<cs_complex_t *>(Xx),
@@ -2143,7 +2144,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < nbuf; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_pvec) (S->q, reinterpret_cast<cs_complex_t *> (Xx),
                               buf, nr);
@@ -2206,7 +2207,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < S->m2; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_ipvec) (S->pinv,
                                reinterpret_cast<cs_complex_t *> (Xx),
@@ -2304,7 +2305,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < nbuf; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_pvec) (S->q,
                               reinterpret_cast<cs_complex_t *> (Xx),
@@ -2392,7 +2393,7 @@
       octave_quit ();

       for (octave_idx_type j = nr; j < S->m2; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_ipvec) (S->pinv, bvec + bidx, buf, nr);

@@ -2460,7 +2461,7 @@
       octave_quit ();

       for (octave_idx_type j = nr; j < nbuf; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_pvec) (S->q, bvec + bidx, buf, nr);
       CXSPARSE_ZNAME (_utsolve) (N->U, buf);
@@ -2522,7 +2523,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < S->m2; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_ipvec) (S->pinv,
                                reinterpret_cast<cs_complex_t *> (Xx),
@@ -2620,7 +2621,7 @@
         Xx[j] = b.xelem (j, i);

       for (octave_idx_type j = nr; j < nbuf; j++)
-        buf[j] = cs_complex_t (0.0, 0.0);
+        buf[j] = 0.0;

       CXSPARSE_ZNAME (_pvec) (S->q, reinterpret_cast<cs_complex_t *>(Xx),
                               buf, nr);