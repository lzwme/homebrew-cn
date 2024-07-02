class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.1.0chapel-2.1.0.tar.gz"
  sha256 "72593c037505dd76e8b5989358b7580a3fdb213051a406adb26a487d26c68c60"
  license "Apache-2.0"
  revision 1
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "3f9e90c98eb1bb7eac6d8efd9e74d8fae13fe480db295f6ebe525acaf2bdb296"
    sha256 arm64_ventura:  "fcffb99bb673abb3bf462c89beb33c735fc8ad909ab7d631c0e19a73eae7e7f3"
    sha256 arm64_monterey: "34e564f7870b9c8093303286dea05d92ee52e9a46c974c405bdb5dd62ea9b375"
    sha256 sonoma:         "bd0c31abc87c2cf3cce274baa551189bdfec28c975ea4e511bc9aefb5b7f7669"
    sha256 ventura:        "ecdb74bf7d09036004561f4259cf67ca9f9c66385f7c654541fd293032182ea2"
    sha256 monterey:       "631a09bb74e26e6b92a80b8e8050926e9686e1e3000833e534751d98e99ee455"
    sha256 x86_64_linux:   "0580d2a4392040690610e1dee948c9e470e129eacaf113bcc56955029e43eeb4"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm"
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

      rm_rf("third-partyllvmllvm-src")
      rm_rf("third-partygasnetgasnet-src")
      rm_rf("third-partylibfabriclibfabric-src")
      rm_rf("third-partyfltkfltk-1.3.5-source.tar.gz")
      rm_rf("third-partylibunwindlibunwind-1.1.tar.gz")
      rm_rf("third-partygmpgmp-src")
      rm_rf("third-partyqthreadqthread-srcinstalled")
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