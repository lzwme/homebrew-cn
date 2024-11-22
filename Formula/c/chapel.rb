class Chapel < Formula
  include Language::Python::Shebang

  desc "Programming language for productive parallel computing at scale"
  homepage "https:chapel-lang.org"
  url "https:github.comchapel-langchapelreleasesdownload2.2.0chapel-2.2.0.tar.gz"
  sha256 "bb16952a87127028031fd2b56781bea01ab4de7c3466f7b6a378c4d8895754b6"
  license "Apache-2.0"
  revision 2
  head "https:github.comchapel-langchapel.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "86a564896112278e0aee551ad00254242ff7eb374da45f945352beb6df974999"
    sha256 arm64_sonoma:  "82a836c46c1742bda66bfe00cc382597007b29dd9a1261eab74316095f0b0790"
    sha256 arm64_ventura: "617283fed12c23b9d61023f77c1b82536b9064913761dd3b266d7055242b2e1a"
    sha256 sonoma:        "9e41f26c78876875e0d6cde3ebd54740b10d0054eb2929915ce1390fcc91ab3d"
    sha256 ventura:       "eb0a0093cd3c9ba5a2347f07c59bae86071ca5baaa8861f094db65ca5df6c2fd"
    sha256 x86_64_linux:  "252515f46ddc6ef16ef46edc26a4a6ad4cc352c6513a138a6a607ae5c7280f39"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm@18"
  depends_on "pkgconf"
  depends_on "python@3.13"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  # update pyyaml to support py3.13 build, upstream pr ref, https:github.comchapel-langchapelpull26079
  patch :DATA

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.13"
    # It should be noted that this will expand to: 'for cmd in python3.13 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "utilconfigfind-python.sh", ^(for cmd in )(python3 ), "\\1#{python} \\2"
    inreplace "third-partychpl-venvMakefile", "python3 -c ", "#{python} -c "

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
      rm_r("third-partyfltkfltk-1.3.8-source.tar.gz")
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

__END__
diff --git athird-partychpl-venvtest-requirements.txt bthird-partychpl-venvtest-requirements.txt
index a8f97300..2da4f7de 100644
--- athird-partychpl-venvtest-requirements.txt
+++ bthird-partychpl-venvtest-requirements.txt
@@ -1,4 +1,4 @@
-PyYAML==6.0.1
+PyYAML==6.0.2
 filelock==3.12.2
 argcomplete==3.1.2
 setuptools==68.0.0