class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.0.0chapel-2.0.0.tar.gz"
  sha256 "b5387e9d37b214328f422961e2249f2687453c2702b2633b7d6a678e544b9a02"
  license "Apache-2.0"
  revision 2
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "b3a17460d5c4004ae428cdcbaa9e6e0ee5f046e8756da0fcdf7c9bed1be0db4f"
    sha256 arm64_ventura:  "f3540dffae9ecb858c67680ef1f17644688222963316f75a5af456595e19c828"
    sha256 arm64_monterey: "af1f15e5f7999846b0c93e3693b8ce3865508d2699b74314271c26eddfa5de2e"
    sha256 sonoma:         "db2e6509a5f9d458b9095dc5712887af288ee71548e81b354bf2b83b31c00264"
    sha256 ventura:        "cdc448f656cb37803345a93feec67e3534dccf1163e1c41bf437c7b31cad5142"
    sha256 monterey:       "71a342127d688105a005d30a1536f97392b5539167cf2186e288268ac871a46b"
    sha256 x86_64_linux:   "892b0b0cb94f7119cfcb01403bd1266b33e944ae50af65aeebff732c91438686"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm@17"
  depends_on "python@3.12"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  # Fixes: SyntaxWarning: invalid escape sequence '\d'
  # Remove when merged: https:github.comchapel-langchapelpull24643
  patch :DATA

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.12"
    # It should be noted that this will expand to: 'for cmd in python3.12 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "utilconfigfind-python.sh", ^(for cmd in )(python3 ), "\\1#{python} \\2"

    # TEMPORARY adds clean-cmakecache target to prevent issues where only
    #           the first make target gets written to the proper CMAKE_RUNTIME_OUTPUT_DIRECTORY
    #           cmake detects a change in compilers (although the values are the same?) and
    #           reruns configure, losing the output directory we set at configure time
    inreplace "compilerMakefile",
              "all: $(PRETARGETS) $(MAKEALLSUBDIRS) echocompilerdir $(TARGETS)\n",
              "all: $(PRETARGETS) $(MAKEALLSUBDIRS) echocompilerdir $(TARGETS)\n\n
              clean-cmakecache: FORCE\n\trm -f $(COMPILER_BUILD)CMakeCache.txt\n\n"

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_MEM=cstdlib
      CHPL_TASKS=fifo
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
        cd "compiler" do
          system "make", "clean-cmakecache"
        end
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        cd "compiler" do
          system "make", "clean-cmakecache"
        end
        system "make", "chpldoc"
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
  end
end

__END__
diff --git autilchplenvcompiler_utils.py butilchplenvcompiler_utils.py
index c4d683830f4c..1d1be1d55521 100644
--- autilchplenvcompiler_utils.py
+++ butilchplenvcompiler_utils.py
@@ -32,7 +32,7 @@ def CompVersion(version_string):
     are not specified, 0 will be used for their value(s)
     """
     CompVersionT = namedtuple('CompVersion', ['major', 'minor', 'revision', 'build'])
-    match = re.search(u'(\d+)(\.(\d+))?(\.(\d+))?(\.(\d+))?', version_string)
+    match = re.search(u"(\\d+)(\\.(\\d+))?(\\.(\\d+))?(\\.(\\d+))?", version_string)
     if match:
         major    = int(match.group(1))
         minor    = int(match.group(3) or 0)