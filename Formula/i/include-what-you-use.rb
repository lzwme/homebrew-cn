class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.25.src.tar.gz"
  sha256 "be81f9d5498881462465060ddc28b587c01254255c706d397d1a494d69eb5efd"
  license "NCSA"
  head "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https://include-what-you-use.org/downloads/"
    regex(/href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "98c00c4267b68a7d1d7650cefdd41d3f14946f689f544c150684ba94044c4176"
    sha256 arm64_sequoia: "e7796887269100ce17a7fd7f1f2d7d3a21a2400bf139930316783aaae3279a91"
    sha256 arm64_sonoma:  "4413bdbe8dad5c421d4c73129d35a505ea82e2c667888f94477a9e60cec06ba6"
    sha256 sonoma:        "2e9b3c08f005502a54aa1423710b48365aacc26425bae1c323ea160155824c09"
    sha256 arm64_linux:   "2e4362a4b9969a76fe629ea7652c26905539643992e0b72312f95f1267f6d538"
    sha256 x86_64_linux:  "1acf1c3309c6ac3e4730fe8c691fb80fb5191b6e2d0cad5132359895e148f13a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
  end

  def install
    # FIXME: CMake stripped out our `llvm` rpath; work around that.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: libexec/"bin", target: llvm.opt_lib)}
    ]

    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec), *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script libexec.glob("bin/*")
    man1.install_symlink libexec.glob("share/man/man1/*")

    # include-what-you-use needs a copy of the clang and libc++ headers to be
    # located in specific folders under its resource path. These may need to be
    # updated when new major versions of llvm are released, i.e., by
    # incrementing the version of include-what-you-use or the revision of this
    # formula. This would be indicated by include-what-you-use failing to
    # locate stddef.h and/or stdlib.h when running the test block below.
    # https://clang.llvm.org/docs/LibTooling.html#libtooling-builtin-includes
    (libexec/"lib").mkpath
    ln_sf (llvm.opt_lib/"clang").relative_path_from(libexec/"lib"), libexec/"lib"
    (libexec/"include").mkpath
    ln_sf (llvm.opt_include/"c++").relative_path_from(libexec/"include"), libexec/"include"
  end

  test do
    (testpath/"direct.h").write <<~C
      #include <stddef.h>
      size_t function() { return (size_t)0; }
    C
    (testpath/"indirect.h").write <<~C
      #include "direct.h"
    C
    (testpath/"main.c").write <<~C
      #include "indirect.h"
      int main() {
        return (int)function();
      }
    C
    expected_output = <<~EOS
      main.c should add these lines:
      #include "direct.h"  // for function

      main.c should remove these lines:
      - #include "indirect.h"  // lines 1-1

      The full include-list for main.c:
      #include "direct.h"  // for function
      ---
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.c 2>&1")

    mapping_file = "#{llvm.opt_include}/c++/v1/libcxx.imp"
    (testpath/"main.cc").write <<~CPP
      #include <iostream>
      int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    expected_output = <<~EOS
      (main.cc has correct #includes/fwd-decls)
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.cc -Xiwyu --mapping_file=#{mapping_file} 2>&1")
  end
end