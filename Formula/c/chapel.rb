class Chapel < Formula
  include Language::Python::Shebang

  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.4.0chapel-2.4.0.tar.gz"
  sha256 "a51a472488290df12d1657db2e7118ab519743094f33650f910d92b54c56f315"
  license "Apache-2.0"
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "59188f8485768959302c9f4a458ff66e5c2c4ece64691fa5a639880936d6c990"
    sha256 arm64_sonoma:  "05e8d2137ebd0722a4d533ffaa3fad94400f98f8b83d6b52c63eef609844fdae"
    sha256 arm64_ventura: "8312360f28974f10d754a44400f399dcdb3758061e6cb350adb3f4459cdd84a1"
    sha256 sonoma:        "b207875a623eaf69641509aa3329fc6baebc1ad6e7d7bbe103b7377a52cf6406"
    sha256 ventura:       "9b1730b815cee7c4e2b2e88d153e7e7ba3c560461cbfe6dcf9c7bddffce00741"
    sha256 x86_64_linux:  "972bc472973e5f3e40826b31f66c30464b8a0fe1e28ac173cfae4a54be54160f"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm"
  depends_on "pkgconf"
  depends_on "python@3.13"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.13"
    # It should be noted that this will expand to: 'for cmd in python3.13 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "utilconfigfind-python.sh", ^(for cmd in )(python3 ), "\\1#{python} \\2"

    # a lot of scripts have a python3 or python shebang, which does not point to python3.12 anymore
    Pathname.glob("***.py") do |pyfile|
      rewrite_shebang detected_python_shebang, pyfile
    end

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # This ENV avoids a problem where cmake cache is invalidated by subsequent make calls
    ENV["CHPL_CMAKE_USE_CC_CXX"] = "1"
    ENV["CHPL_CMAKE_PYTHON"] = python

    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_TARGET_MEM=jemalloc
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
      rm_r("third-partylibunwindlibunwind-src")
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