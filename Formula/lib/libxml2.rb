class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http:xmlsoft.org"
  license "MIT"

  stable do
    url "https:download.gnome.orgsourceslibxml22.13libxml2-2.13.6.tar.xz"
    sha256 "f453480307524968f7a04ec65e64f2a83a825973bcd260a2e7691be82ae70c96"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix pkg-config checks for libicuuc. Patch taken from:
    # https:gitlab.gnome.orgGNOMElibxml2-commitb57e022d75425ef8b617a1c3153198ee0a941da8
    # When the patch is no longer needed, remove along with the `stable` block
    # and the autotools dependencies above. Also uncomment `if build.head?`
    # condition in the `install` block.
    patch :DATA
  end

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(libxml2[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "674576ac834e127f3938d10c6edcacce4892f789f80d61dee4f9d0f47aef398f"
    sha256 cellar: :any,                 arm64_sonoma:  "5b0519464a06fe588c8b8aab0052852369250f82f2ebc91bc6325876bea4e1e8"
    sha256 cellar: :any,                 arm64_ventura: "060d66e316935cbdab9232ad6e68568d38c320a437e212c4e540b508d37107e4"
    sha256 cellar: :any,                 sonoma:        "6df0aa4c5a0875ea3123b1c1542bd37b0555119a95dcc4f1499fd4833026f937"
    sha256 cellar: :any,                 ventura:       "b600fe412e38deecdd01ef52feeb9a605d1926d68add75d84ebaa1e2f6e92bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe7dbf126d30007a06f9c23cfd43fe9c5e84f244de59b33e4c172db8ed74a1e"
  end

  head do
    url "https:gitlab.gnome.orgGNOMElibxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "icu4c@76"
  depends_on "readline"

  uses_from_macos "zlib"

  def icu4c
    deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
        .to_formula
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@\d\.\d+$) }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    # Work around build failure due to icu4c 75+ adding -std=c11 to installed
    # files when built without manually setting "-std=" in CFLAGS. This causes
    # issues on Linux for `libxml2` as `addrinfo` needs GNU extensions.
    # nanohttp.c:1019:42: error: invalid use of undefined type 'struct addrinfo'
    ENV.append "CFLAGS", "-std=gnu11" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" # if build.head?
    system ".configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--with-history",
                          "--with-http",
                          "--with-icu",
                          "--with-legacy", # https:gitlab.gnome.orgGNOMElibxml2-issues751#note_2157870
                          "--without-lzma",
                          "--without-python",
                          *std_configure_args
    system "make", "install"

    inreplace [bin"xml2-config", lib"pkgconfiglibxml-2.0.pc"] do |s|
      s.gsub! prefix, opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix, audit_result: false
    end

    # `icu4c` is keg-only, so we need to tell `pkg-config` where to find its
    # modules.
    if OS.mac?
      icu_uc_pc = icu4c.opt_lib"pkgconfigicu-uc.pc"
      inreplace lib"pkgconfiglibxml-2.0.pc",
                ^Requires\.private:(.*)\bicu-uc\b(.*)$,
                "Requires.private:\\1#{icu_uc_pc}\\2"
    end

    sdk_include = if OS.mac?
      sdk = MacOS.sdk_path_if_needed
      sdk"usrinclude" if sdk
    else
      HOMEBREW_PREFIX"include"
    end

    includes = [include, sdk_include].compact.map do |inc|
      "'#{inc}',"
    end.join(" ")

    # We need to insert our include dir first
    inreplace "pythonsetup.py", "includes_dir = [",
                                 "includes_dir = [#{includes}"

    # Needed for Python 3.12+.
    # https:github.comHomebrewhomebrew-corepull154551#issuecomment-1820102786
    with_env(PYTHONPATH: buildpath"python") do
      pythons.each do |python|
        system python, "-m", "pip", "install", *std_pip_args, ".python"
      end
    end
  end

  test do
    (testpath"test.c").write <<~C
      #include <libxmltree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    C

    # Test build with xml2-config
    args = shell_output("#{bin}xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system ".test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib"pkgconfig"
    args = shell_output("#{Formula["pkgconf"].opt_bin}pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system ".test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefixLanguage::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end

    # Make sure cellar paths are not baked into these files.
    [bin"xml2-config", lib"pkgconfiglibxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end

__END__
diff --git aconfigure.ac bconfigure.ac
index c6dc93d58f84f21c4528753d2ee1bc1d50e67ced..e7bad24d8f1aa7659e1aa4e2ad1986cc2167483b 100644
--- aconfigure.ac
+++ bconfigure.ac
@@ -984,10 +984,10 @@ if test "$with_icu" != "no" && test "$with_icu" != "" ; then

     # Try pkg-config first so that static linking works.
     # If this succeeeds, we ignore the WITH_ICU directory.
-    PKG_CHECK_MODULES([ICU], [icu-i18n], [
-        WITH_ICU=1; XML_PC_REQUIRES="${XML_PC_REQUIRES} icu-i18n"
+    PKG_CHECK_MODULES([ICU], [icu-uc], [
+        WITH_ICU=1; XML_PC_REQUIRES="${XML_PC_REQUIRES} icu-uc"
         m4_ifdef([PKG_CHECK_VAR],
-            [PKG_CHECK_VAR([ICU_DEFS], [icu-i18n], [DEFS])])
+            [PKG_CHECK_VAR([ICU_DEFS], [icu-uc], [DEFS])])
         if test "x$ICU_DEFS" != "x"; then
             ICU_CFLAGS="$ICU_CFLAGS $ICU_DEFS"
         fi],[:])