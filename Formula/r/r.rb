class R < Formula
  desc "Software environment for statistical computing"
  homepage "https:www.r-project.org"
  url "https:cran.r-project.orgsrcbaseR-4R-4.5.0.tar.gz"
  sha256 "3b33ea113e0d1ddc9793874d5949cec2c7386f66e4abfb1cef9aec22846c3ce1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:cran.rstudio.combanner.shtml"
    regex(%r{href=(?:["']?|.*?)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "d1ddce0ad0d522ee76fb51606bf534c657485926b84abdcc639d44c597092b1f"
    sha256 arm64_sonoma:  "863812140563d5032eba8bd4fbad25a1491959211859fbbd771360cdb9bee4f9"
    sha256 arm64_ventura: "975e8373997f5d7fc5410dac375f17cfa974e75faf60ae03174d2975577ac95e"
    sha256 sonoma:        "c5b065319f527a4f58980dcd755924e2bed7219c126f219d1e1fb28185665810"
    sha256 ventura:       "39f5db524319dab2d2a0c38d26b76fb11d48e5b8a800a6d997642334f252af12"
    sha256 arm64_linux:   "0a4686667b78d716ae8011cd23a3c87d770195d4675d501132f205c2b3d9096d"
    sha256 x86_64_linux:  "c9cf750aeabb259ff475472ac3cf9e720c43eed195aa72f495f5eafaf16913ad"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libxext"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tcl-tk@8"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxau"
    depends_on "libxcb"
    depends_on "libxdmcp"
    depends_on "libxrender"
    depends_on "pixman"
  end

  on_linux do
    depends_on "glib"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libtirpc"
    depends_on "libx11"
    depends_on "libxt"
    depends_on "pango"
  end

  # needed to preserve executable permissions on files without shebangs
  skip_clean "libRbin", "libRdoc"

  # Fix build with clang 17
  # https:github.comwchr-sourcecommit489a6b8d330bb30da82329f1949f44a0f633f1e8
  patch :DATA

  def install
    # `configure` doesn't like curl 8+, but convince it that everything is ok.
    # TODO: report this upstream.
    ENV["r_cv_have_curl728"] = "yes"

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-tcl-config=#{Formula["tcl-tk@8"].opt_lib}tclConfig.sh",
      "--with-tk-config=#{Formula["tcl-tk@8"].opt_lib}tkConfig.sh",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--enable-R-shlib",
      "--disable-java",
      "--with-cairo",
      # This isn't necessary to build R, but it's saved in Makeconf
      # and helps CRAN packages find gfortran when Homebrew may not be
      # in PATH (e.g. under RStudio, launched from Finder)
      "FC=#{Formula["gcc"].opt_bin}gfortran",
    ]

    if OS.mac?
      args << "--without-x"
      args << "--with-aqua"
    else
      args << "--libdir=#{lib}" # avoid using lib64 on CentOS

      # Avoid references to homebrew shims
      args << "LD=ld"

      # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
      # search those directories. Remove -LHOMEBREW_PREFIXlib from LDFLAGS.
      ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}lib"

      ENV.append "CPPFLAGS", "-I#{Formula["libtirpc"].opt_include}tirpc"
      ENV.append "LDFLAGS", "-L#{Formula["libtirpc"].opt_lib}"
    end

    # Help CRAN packages find gettext and readline
    ["gettext", "readline", "xz"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    system ".configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    system "make", "-C", "srcnmathstandalone"
    ENV.deparallelize do
      system "make", "-C", "srcnmathstandalone", "install"
    end

    r_home = lib"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home"etcMakeconf" do |s|
      s.gsub!(^CPPFLAGS =.*, "\\0 -I#{HOMEBREW_PREFIX}include")
      s.gsub!(^LDFLAGS =.*, "\\0 -L#{HOMEBREW_PREFIX}lib")
      s.gsub!(.LDFLAGS =.*, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home"include*"]
    lib.install_symlink Dir[r_home"lib*"]

    # avoid triggering mandatory rebuilds of r when gcc is upgraded
    inreplace lib"RetcMakeconf", Formula["gcc"].prefix.realpath,
                                    Formula["gcc"].opt_prefix,
                                    audit_result: OS.mac?
  end

  def post_install
    short_version = Utils.safe_popen_read(bin"Rscript", "-e", "cat(as.character(getRversion()[1,1:2]))")
    site_library = HOMEBREW_PREFIX"libR"short_version"site-library"
    site_library.mkpath
    touch site_library".keepme"
    site_library_cellar = lib"Rsite-library"
    site_library_cellar.unlink if site_library_cellar.exist?
    site_library_cellar.parent.install_symlink site_library
  end

  test do
    assert_equal "[1] 2", shell_output("#{bin}Rscript -e 'print(1+1)'").chomp
    assert_equal shared_library(""), shell_output("#{bin}R CMD config DYLIB_EXT").chomp
    system bin"Rscript", "-e", "if(!capabilities('cairo')) stop('cairo not available')"

    system bin"Rscript", "-e", "install.packages('gss', '.', 'https:cloud.r-project.org')"
    assert_path_exists testpath"gsslibsgss.so", "Failed to install gss package"

    winsys = "[1] \"aqua\""
    if OS.linux?
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      winsys = "[1] \"x11\""
    end
    assert_equal winsys,
                 shell_output("#{bin}Rscript -e 'library(tcltk)' -e 'tclvalue(.Tcl(\"tk windowingsystem\"))'").chomp
  end
end
__END__
diff -pur R-4.5.0srcnmathmlutils.c R-4.5.0-patchedsrcnmathmlutils.c
--- R-4.5.0srcnmathmlutils.c	2025-03-14 00:02:15
+++ R-4.5.0-patchedsrcnmathmlutils.c	2025-05-24 12:16:15
@@ -105,7 +105,20 @@ double R_pow_di(double x, int n)
     return pow;
 }
 
+* It is not clear why these are being defined in standalone nmath:
+ * but that they are is stated in the R-admin manual.
+ *
+ * In R NA_AREAL is a specific NaN computed during initialization.
+ *
+#if defined(__clang__) && defined(NAN)
+ C99 (optionally) has NAN, which is a float but will coerce to double.
+double NA_REAL = NAN;
+#else
+ ML_NAN is defined as (0.00.0) in nmath.h
+ Fails to compile in Intel ics 2025.0, Apple clang 17, LLVM clang 20
 double NA_REAL = ML_NAN;
+#endif
+
 double R_PosInf = ML_POSINF, R_NegInf = ML_NEGINF;
 
 #include <stdio.h>