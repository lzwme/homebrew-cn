class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https:www.ghostscript.com"
  license "AGPL-3.0-or-later"

  stable do
    url "https:github.comArtifexSoftwareghostpdl-downloadsreleasesdownloadgs10021ghostpdl-10.02.1.tar.xz"
    sha256 "01f4b699f031566b04cec495506811866e17896b26847c14e5333fb3adfc0619"

    on_macos do
      # 1. Make sure shared libraries follow platform naming conventions.
      # 2. Prevent dependent rebuilds on minor version bumps.
      # Reported upstream at:
      #   https:bugs.ghostscript.comshow_bug.cgi?id=705907
      #   https:bugs.ghostscript.comshow_bug.cgi?id=705908
      patch :DATA
    end
  end

  # The GitHub tags omit delimiters (e.g. `gs9533` for version 9.53.3). The
  # `head` repository tags are formatted fine (e.g. `ghostpdl-9.53.3`) but a
  # version may be tagged before the release is available on GitHub, so we
  # check the version from the first-party website instead.
  livecheck do
    url "https:www.ghostscript.comjsonsettings.json"
    regex(["']GS_VER["']:\s*?["']v?(\d+(?:\.\d+)+)["']i)
  end

  bottle do
    sha256 arm64_sonoma:   "40d5580ead459aefe68afa9598cf9a78b2986728b1facd65197dee6d515bb89b"
    sha256 arm64_ventura:  "c5db66858cd4a9adf1c2550aaecac97e9dc77d909ce383c7237e21e9296ff5eb"
    sha256 arm64_monterey: "6827f568486864faef458a93639ab434f6ac462851a7174e032920af1560f5fb"
    sha256 sonoma:         "16c06c980a9042d4cc6bfb25066bbd5115e79844491e52ed9d14b2e70cdc229f"
    sha256 ventura:        "1bd495710c4e3dd8c82910da392b31bb62031c0367ca33b833a190911bd4cde9"
    sha256 monterey:       "aa61f407ef7001d70f2999cc41856376ed3e02d816018f1ae6178f921000f693"
    sha256 x86_64_linux:   "2991d1596604df285d584c401eec3b226a4846adf27cdf32493547e08db5e613"
  end

  head do
    url "https:git.ghostscript.comghostpdl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "gambit-scheme", because: "both install `gsc` binary"

  fails_with gcc: "5"

  # https:sourceforge.netprojectsgs-fonts
  resource "fonts" do
    url "https:downloads.sourceforge.netprojectgs-fontsgs-fonts8.11%20%28base%2035%2C%20GPL%29ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  # fmemopen is only supported from 10.13 onwards (https:news.ycombinator.comitem?id=25968777).
  # For earlier versions of MacOS, needs to be excluded.
  # This should be removed once patch added to next release of leptonica (which is incorporated by ghostscript in
  # tarballs).
  patch do
    url "https:github.comDanBloombergleptonicacommit848df62ff7ad06965dd77ac556da1b2878e5e575.patch?full_index=1"
    sha256 "7de1c4e596aad5c3d2628b309cea1e4fc1ff65e9c255fe64de1922b3fd2d60fc"
    directory "leptonica"
  end

  def install
    # Delete local vendored sources so build uses system dependencies
    libs = %w[expat freetype jbig2dec jpeg lcms2mt libpng openjpeg tiff zlib]
    libs.each { |l| (buildpathl).rmtree }

    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, *std_configure_args,
                      "--disable-compile-inits",
                      "--disable-cups",
                      "--disable-gtk",
                      "--with-system-libtiff",
                      "--without-x"

    # Install binaries and libraries
    system "make", "install"
    ENV.deparallelize { system "make", "install-so" }

    (pkgshare"fonts").install resource("fonts")
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match "Hello World!", shell_output("#{bin}ps2ascii #{ps}")
  end
end

__END__
diff --git abaseunix-dll.mak bbaseunix-dll.mak
index 89dfa5a..c907831 100644
--- abaseunix-dll.mak
+++ bbaseunix-dll.mak
@@ -100,10 +100,26 @@ GS_DLLEXT=$(DLL_EXT)
 
 
 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+PCL_SONAME=$(PCL_SONAME_BASE).$(GS_SOEXT)
+PCL_SONAME_MAJOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+PCL_SONAME_MAJOR_MINOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+XPS_SONAME=$(XPS_SONAME_BASE).$(GS_SOEXT)
+XPS_SONAME_MAJOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+XPS_SONAME_MAJOR_MINOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+PDF_SONAME=$(PDF_SONAME_BASE).$(GS_SOEXT)
+PDF_SONAME_MAJOR=$(PDF_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+PDF_SONAME_MAJOR_MINOR=$(PDF_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+
+GPDL_SONAME=$(GPDL_SONAME_BASE).$(GS_SOEXT)
+GPDL_SONAME_MAJOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GPDL_SONAME_MAJOR_MINOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
 #LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)
diff --git aconfigure bconfigure
index bfa0985..8de469c 100755
--- aconfigure
+++ bconfigure
@@ -12805,11 +12805,11 @@ case $host in
     ;;
     *-darwin*)
       DYNAMIC_CFLAGS="-fPIC $DYNAMIC_CFLAGS"
-      GS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GS_SONAME_MAJOR_MINOR)"
-      PCL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PCL_SONAME_MAJOR_MINOR)"
-      XPS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(XPS_SONAME_MAJOR_MINOR)"
-      PDL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GPDL_SONAME_MAJOR_MINOR)"
-      PDF_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PDF_SONAME_MAJOR_MINOR)"
+      GS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GS_SONAME_MAJOR)"
+      PCL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PCL_SONAME_MAJOR)"
+      XPS_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(XPS_SONAME_MAJOR)"
+      PDL_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(GPDL_SONAME_MAJOR)"
+      PDF_DYNAMIC_LDFLAGS="-dynamiclib -install_name $DARWIN_LDFLAGS_SO_PREFIX\$(PDF_SONAME_MAJOR)"
       DYNAMIC_LIBS=""
       SO_LIB_EXT=".dylib"
     ;;