class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.0.0chapel-2.0.0.tar.gz"
  sha256 "b5387e9d37b214328f422961e2249f2687453c2702b2633b7d6a678e544b9a02"
  license "Apache-2.0"
  revision 1
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "ec1f28ac19706339cfe68d8d19e3d7688a7c9eaf667bba2dc244be6d11e86839"
    sha256 arm64_ventura:  "e978dfceb8fbcec0f91c8e72bc8ff625c194c1439c9e966301becd8dbe0fef7b"
    sha256 arm64_monterey: "39e59768ce541ace13ab1d4c76e757d3ccd70d48607f440bff4ec3491fc6e754"
    sha256 sonoma:         "8f9626f77073baa1d5c8b16588093d721aecf0c2898ae50e5b5bd64dffcc3507"
    sha256 ventura:        "ef24c5a5f424bd5689ea5027caad805ddaabbc60e734bc0bcb09049d2a4941c2"
    sha256 monterey:       "1ebdab2f1045a7c34e26a15974a54f47ab6a46cc1f558b4f7cb090e3f281110b"
    sha256 x86_64_linux:   "a8ee6968f4b9576b79a5d6b487fccfcf90b5f1dd2e0ebe00b3dcebe33ced404f"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm"
  depends_on "python@3.11"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.11"
    # It should be noted that this will expand to: 'for cmd in python3.11 python3 python python2; do'
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