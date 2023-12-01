class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://ghproxy.com/https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1009.2.tar.gz"
  sha256 "da3b7d3a9069e9c0138416e3ec56dbb7dd165b73d108d3cee6397031d9582255"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09f5ebd19cf69d050cdfe07449b88af12332a0f4a4ae00ffd2aca2686b7f65d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62f8e6169d30a003ccfe37f099c16e067d0eb155ebb3493378d18230b47d525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb34a8d6ea6ecb1d36df9a138a0940eaf9e11dfdd2fe1f7f3f196e34c0d7aa2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf68d8e1eeebac0d968f6602033d3e849f5e11b6e4f85cc9491057250ced9b15"
    sha256 cellar: :any_skip_relocation, ventura:        "b80782da42c2a981fb9c373fa351d8181d1c32b365ed1115a6b9ca856c812b45"
    sha256 cellar: :any_skip_relocation, monterey:       "8799642d1f54cb65371b1dd19dd70778aed1418678a25f636db50d2908e7e6ef"
  end

  depends_on "llvm" => :build
  depends_on :macos
  conflicts_with "ocmtoc", because: "both install `mtoc` binaries"

  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/acidanthera/ocbuild/d3e57820ce85bc2ed4ce20cc25819e763c17c114/patches/mtoc-permissions.patch"
    sha256 "0d20ee119368e30913936dfee51055a1055b96dde835f277099cb7bcd4a34daf"
  end

  # Rearrange #include's to avoid macros defining function argument names in
  # LLVM's headers.
  patch :DATA

  def install
    # error: DT_TOOLCHAIN_DIR cannot be used to evaluate HEADER_SEARCH_PATHS, use TOOLCHAIN_DIR instead
    inreplace "xcode/libstuff.xcconfig", "${DT_TOOLCHAIN_DIR}/usr/local/include",
                                         Formula["llvm"].opt_include

    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "CONFIGURATION_BUILD_DIR=build/Release",
               "HEADER_SEARCH_PATHS=#{Formula["llvm"].opt_include} $(HEADER_SEARCH_PATHS)"
    bin.install "build/Release/mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system ENV.cc, *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end

__END__
diff --git a/libstuff/lto.c b/libstuff/lto.c
index ee9fc32..29b986c 100644
--- a/libstuff/lto.c
+++ b/libstuff/lto.c
@@ -6,8 +6,8 @@
 #include <sys/file.h>
 #include <dlfcn.h>
 #include <llvm-c/lto.h>
-#include "stuff/ofile.h"
 #include "stuff/llvm.h"
+#include "stuff/ofile.h"
 #include "stuff/lto.h"
 #include "stuff/allocate.h"
 #include "stuff/errors.h"