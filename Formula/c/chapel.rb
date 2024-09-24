class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.1.0chapel-2.1.0.tar.gz"
  sha256 "72593c037505dd76e8b5989358b7580a3fdb213051a406adb26a487d26c68c60"
  license "Apache-2.0"
  revision 3
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "2d501f1424bc9f21bfad56bcfc556cf8712e524db4fcbf57ee2cb18b59673be4"
    sha256 arm64_sonoma:  "c16920ce4c25f8d530ad0fb9612c8d7caaafa53246b2a747dbf5e3115c46dfe8"
    sha256 arm64_ventura: "cc1f389cfd794bac980e53a42ca8e9c0255c9f73c6986adbd94722a27fe55733"
    sha256 sonoma:        "8cbef3e52afed90588890167c3be772a33511faaf83ff2bdde68335b657167bf"
    sha256 ventura:       "5e50cc8ad9a26b24125f4b725038a5a312068f7cd05273cbe01dcc56b5d50c4a"
    sha256 x86_64_linux:  "67c2451db78969ab1a7031ed8b6758b02da7ca728ae11ca41b8d7ff3321d2ed6"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm@18"
  depends_on "pkg-config"
  depends_on "python@3.12"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  # This fixes an issue when using jemalloc and hwloc from the system (homebrew)
  # provided installation. Remove in Chapel 2.2 release, after
  # https:github.comchapel-langchapelpull25354 is merged
  patch :DATA

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.12"
    # It should be noted that this will expand to: 'for cmd in python3.12 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "utilconfigfind-python.sh", ^(for cmd in )(python3 ), "\\1#{python} \\2"

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # This ENV avoids a problem where cmake cache is invalidated by subsequent make calls
    ENV["CHPL_CMAKE_USE_CC_CXX"] = "1"

    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_MEM=jemalloc
      CHPL_TARGET_JEMALLOC=system
      CHPL_HWLOC=system
      CHPL_LLVM_CONFIG=#{llvm.opt_bin}llvm-config
      CHPL_LLVM_GCC_PREFIX=none
    EOS

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https:github.comHomebrewlegacy-homebrewpull35166
    cd libexec do
      system ".utilprintchplenv", "--all"
      with_env(CHPL_LLVM: "none") do
        system "make"
      end
      with_env(CHPL_LLVM: "system") do
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "chpldoc"
        system "make", "chplcheck"
        system "make", "chpl-language-server"
      end
      system "make", "mason"
      system "make", "cleanall"

      rm_r("third-partyllvmllvm-src")
      rm_r("third-partygasnetgasnet-src")
      rm_r("third-partylibfabriclibfabric-src")
      rm_r("third-partygmpgmp-src")
      rm_r("third-partyqthreadqthread-src")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arch}"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    bin.install libexec.glob("bin#{platform}*")
    bin.env_script_all_files libexec"bin"platform, CHPL_HOME: libexec
    man1.install_symlink libexec.glob("manman1*.1")
  end

  test do
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX"lib"
    cd libexec do
      with_env(CHPL_LLVM: "system") do
        system "utiltestcheckChplInstall"
        system "utiltestcheckChplDoc"
      end
      with_env(CHPL_LLVM: "none") do
        system "utiltestcheckChplInstall"
        system "utiltestcheckChplDoc"
      end
    end
    system bin"chpl", "--print-passes", "--print-commands", libexec"exampleshello.chpl"
    system bin"chpldoc", "--version"
    system bin"mason", "--version"

    # Test chplcheck, if it works CLS probably does too.
    # chpl-language-server will hang indefinitely waiting for a LSP client
    system bin"chplcheck", "--list-rules"
    system bin"chplcheck", libexec"exampleshello.chpl"
  end
end

__END__
diff --git athird-partyjemallocMakefile.target.include bthird-partyjemallocMakefile.target.include
deleted file mode 100644
index 217a500dfb..0000000000
--- athird-partyjemallocMakefile.target.include
+++ devnull
@@ -1,12 +0,0 @@
-JEMALLOC_DIR=$(THIRD_PARTY_DIR)jemalloc
-JEMALLOC_SUBDIR = $(JEMALLOC_DIR)jemalloc-src
-JEMALLOC_BUILD_SUBDIR=build$(CHPL_MAKE_TARGET_JEMALLOC_UNIQ_CFG_PATH)
-JEMALLOC_BUILD_DIR=$(JEMALLOC_DIR)$(JEMALLOC_BUILD_SUBDIR)
-JEMALLOC_INSTALL_SUBDIR=install$(CHPL_MAKE_TARGET_JEMALLOC_UNIQ_CFG_PATH)
-JEMALLOC_INSTALL_DIR=$(JEMALLOC_DIR)$(JEMALLOC_INSTALL_SUBDIR)
-JEMALLOC_INCLUDE_DIR = $(JEMALLOC_INSTALL_DIR)include
-JEMALLOC_LIB_DIR = $(JEMALLOC_INSTALL_DIR)lib
-JEMALLOC_BIN_DIR = $(JEMALLOC_INSTALL_DIR)bin
-JEMALLOC_TARGET = --target
-
-CHPL_JEMALLOC_PREFIX=$(CHPL_JEMALLOC_TARGET_PREFIX)
diff --git amakeMakefile.base bmakeMakefile.base
index bcbda0a9cf..1120057d47 100644
--- amakeMakefile.base
+++ bmakeMakefile.base
@@ -194,7 +194,7 @@ include $(THIRD_PARTY_DIR)jemallocMakefile.common.include
 ifeq ($(strip $(CHPL_MAKE_HOST_TARGET)),--host)
 include $(THIRD_PARTY_DIR)jemallocMakefile.host.include-$(CHPL_MAKE_HOST_JEMALLOC)
 else
-include $(THIRD_PARTY_DIR)jemallocMakefile.target.include
+include $(THIRD_PARTY_DIR)jemallocMakefile.target.include-$(CHPL_MAKE_TARGET_JEMALLOC)
 endif
 include $(THIRD_PARTY_DIR)gmpMakefile.include
 include $(THIRD_PARTY_DIR)hwlocMakefile.include
diff --git athird-partyjemallocMakefile.target.include-bundled bthird-partyjemallocMakefile.target.include-bundled
new file mode 100644
index 0000000000..217a500dfb
--- devnull
+++ bthird-partyjemallocMakefile.target.include-bundled
@@ -0,0 +1,12 @@
+JEMALLOC_DIR=$(THIRD_PARTY_DIR)jemalloc
+JEMALLOC_SUBDIR = $(JEMALLOC_DIR)jemalloc-src
+JEMALLOC_BUILD_SUBDIR=build$(CHPL_MAKE_TARGET_JEMALLOC_UNIQ_CFG_PATH)
+JEMALLOC_BUILD_DIR=$(JEMALLOC_DIR)$(JEMALLOC_BUILD_SUBDIR)
+JEMALLOC_INSTALL_SUBDIR=install$(CHPL_MAKE_TARGET_JEMALLOC_UNIQ_CFG_PATH)
+JEMALLOC_INSTALL_DIR=$(JEMALLOC_DIR)$(JEMALLOC_INSTALL_SUBDIR)
+JEMALLOC_INCLUDE_DIR = $(JEMALLOC_INSTALL_DIR)include
+JEMALLOC_LIB_DIR = $(JEMALLOC_INSTALL_DIR)lib
+JEMALLOC_BIN_DIR = $(JEMALLOC_INSTALL_DIR)bin
+JEMALLOC_TARGET = --target
+
+CHPL_JEMALLOC_PREFIX=$(CHPL_JEMALLOC_TARGET_PREFIX)
diff --git athird-partyjemallocMakefile.target.include-none bthird-partyjemallocMakefile.target.include-none
new file mode 100644
index 0000000000..e69de29bb2
--- devnull
+++ bthird-partyjemallocMakefile.target.include-none
@@ -0,0 +1 @@
+
diff --git athird-partyjemallocMakefile.target.include-system bthird-partyjemallocMakefile.target.include-system
new file mode 100644
index 0000000000..e69de29bb2
--- devnull
+++ bthird-partyjemallocMakefile.target.include-system
@@ -0,0 +1 @@
+
diff --git autilchplenvchpl_hwloc.py butilchplenvchpl_hwloc.py
index cda5ed6bc0..9dc7f0355d 100755
--- autilchplenvchpl_hwloc.py
+++ butilchplenvchpl_hwloc.py
@@ -61,7 +61,13 @@ def get_link_args():
             if exists and retcode != 0:
                 error("CHPL_HWLOC=system requires hwloc >= 2.1", ValueError)

-            return third_party_utils.pkgconfig_get_system_link_args('hwloc')
+            _, pclibs = third_party_utils.pkgconfig_get_system_link_args('hwloc', static=False)
+            libs = []
+            for pcl in pclibs:
+                libs.append(pcl)
+                if pcl.startswith('-L'):
+                    libs.append(pcl.replace('-L', '-Wl,-rpath,', 1))
+            return ([ ], libs)
         else:
             third_party_utils.could_not_find_pkgconfig_pkg("hwloc", "CHPL_HWLOC")

diff --git autilchplenvchpl_jemalloc.py butilchplenvchpl_jemalloc.py
index 3d665fa56b..78761c1c6e 100644
--- autilchplenvchpl_jemalloc.py
+++ butilchplenvchpl_jemalloc.py
@@ -129,7 +129,13 @@ def get_link_args(flag):
         # try pkg-config
         args = third_party_utils.pkgconfig_get_system_link_args('jemalloc')
         if args != (None, None):
-            return args
+            pclibs = args[1]
+            libs = []
+            for pcl in pclibs:
+                libs.append(pcl)
+                if pcl.startswith('-L'):
+                    libs.append(pcl.replace('-L', '-Wl,-rpath,', 1))
+            return (args[0], libs)
         else:
             envname = "CHPL_TARGET_JEMALLOC" if flag == "target" else "CHPL_HOST_JEMALLOC"
             third_party_utils.could_not_find_pkgconfig_pkg("jemalloc", envname)