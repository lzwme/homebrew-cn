class Chapel < Formula
  include Language::Python::Shebang

  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.4.0chapel-2.4.0.tar.gz"
  sha256 "a51a472488290df12d1657db2e7118ab519743094f33650f910d92b54c56f315"
  license "Apache-2.0"
  revision 2
  head "https:github.comchapel-langchapel.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "ae45c935d3a083686ffc20b62e84b0faae9d5a9701322f338ff29bcb6e377c68"
    sha256 arm64_sonoma:  "386cffb16177a8d299f5f4bff38e15a90c2fa7c076c92fb9fc258ecc968b0a43"
    sha256 arm64_ventura: "f7e776bdf704ff263140b01842811bcee6d553876243be35f3d12cc169b2088b"
    sha256 sonoma:        "9ea3c09df45a048ea89d80eef45631a30c9075f1f325c6d2485893304f8e60bc"
    sha256 ventura:       "31436bc68ae8d8ba2efe0326cfcf36f42f291be14249163bbedef1b6f9363154"
    sha256 arm64_linux:   "acf21794e41a00f9b1e0073c5ce8eb2a00bcf5f57266345d06d8fc7aa467ce5e"
    sha256 x86_64_linux:  "04c1f4dab972ad1296acf69e8a68e8f85d6b43f3c1e5a940dd0894c4613dc53f"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm@19"
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
      "linux64-#{Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch}"
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