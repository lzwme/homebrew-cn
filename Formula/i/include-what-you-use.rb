class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https:include-what-you-use.org"
  url "https:include-what-you-use.orgdownloadsinclude-what-you-use-0.23.src.tar.gz"
  sha256 "0004d5a9169717acf2f481248a5bfc15c7d55ddc2b9cdc7f461b06e93d49c73f"
  license "NCSA"
  revision 1
  head "https:github.cominclude-what-you-useinclude-what-you-use.git", branch: "master"

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https:include-what-you-use.orgdownloads"
    regex(href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "992bcae1adce340839e14895f8c1d5dfb4c1ea94e56f46569cc06f948f0a94a3"
    sha256 arm64_sonoma:  "56c21a6df0e2f9ecdc34107f113b9bb147aa0ce14b5844c530e2696ac07595fe"
    sha256 arm64_ventura: "bdeae088acac5f5966165c9bed6b9aebcab4c842b3ea19646ca19f42481dcb55"
    sha256 sonoma:        "6d1301241c77a08b4a094bd19c26851c297beb69459b2a558fea91c110fe670b"
    sha256 ventura:       "7dfc91b48fe2e032365f624e76ac99355eef024cb401f50a4bf51528ed8a8cbe"
    sha256 arm64_linux:   "eb79e0e4ff90aa51e95c0941a7c5f418af98fe07e9e2c78da7588baac8f14e46"
    sha256 x86_64_linux:  "8b548f76a68a04fd8dc112d139217fbe02ea8cf1aed7258c992b94769887f604"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+(\.\d+)*)?$) }
  end

  def install
    # FIXME: CMake stripped out our `llvm` rpath; work around that.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: libexec"bin", target: llvm.opt_lib)}
    ]

    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec), *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script libexec.glob("bin*")
    man1.install_symlink libexec.glob("sharemanman1*")

    # include-what-you-use needs a copy of the clang and libc++ headers to be
    # located in specific folders under its resource path. These may need to be
    # updated when new major versions of llvm are released, i.e., by
    # incrementing the version of include-what-you-use or the revision of this
    # formula. This would be indicated by include-what-you-use failing to
    # locate stddef.h andor stdlib.h when running the test block below.
    # https:clang.llvm.orgdocsLibTooling.html#libtooling-builtin-includes
    (libexec"lib").mkpath
    ln_sf (llvm.opt_lib"clang").relative_path_from(libexec"lib"), libexec"lib"
    (libexec"include").mkpath
    ln_sf (llvm.opt_include"c++").relative_path_from(libexec"include"), libexec"include"
  end

  test do
    (testpath"direct.h").write <<~C
      #include <stddef.h>
      size_t function() { return (size_t)0; }
    C
    (testpath"indirect.h").write <<~C
      #include "direct.h"
    C
    (testpath"main.c").write <<~C
      #include "indirect.h"
      int main() {
        return (int)function();
      }
    C
    expected_output = <<~EOS
      main.c should add these lines:
      #include "direct.h"   for function

      main.c should remove these lines:
      - #include "indirect.h"   lines 1-1

      The full include-list for main.c:
      #include "direct.h"   for function
      ---
    EOS
    assert_match expected_output,
      shell_output("#{bin}include-what-you-use main.c 2>&1")

    mapping_file = "#{llvm.opt_include}c++v1libcxx.imp"
    (testpath"main.cc").write <<~CPP
      #include <iostream>
      int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    expected_output = <<~EOS
      (main.cc has correct #includesfwd-decls)
    EOS
    assert_match expected_output,
      shell_output("#{bin}include-what-you-use main.cc -Xiwyu --mapping_file=#{mapping_file} 2>&1")
  end
end