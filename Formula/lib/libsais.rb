class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https:github.comIlyaGrebnovlibsais"
  url "https:github.comIlyaGrebnovlibsaisarchiverefstagsv2.8.2.tar.gz"
  sha256 "a17918936d6231cf6b019629d65ad7170f889bab5eb46c09b775dede7d890502"
  license "Apache-2.0"
  head "https:github.comIlyaGrebnovlibsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "098bc7400b0932381ddafe57c5779a0ae8ee7cdbca8f0659df2d482b80c44895"
    sha256 cellar: :any,                 arm64_ventura:  "9372d8d51fb75d3c06659d808fc4f1c1a02a108310f355738ac03c82692ee762"
    sha256 cellar: :any,                 arm64_monterey: "4cd287fba8a077ab105772dc0b660cfc5a1a5b7349d997a61a007c138c2fdca4"
    sha256 cellar: :any,                 sonoma:         "c35462845a540c33c8035220c1c22108d63a548b333908eab44dfe54febb0b51"
    sha256 cellar: :any,                 ventura:        "4c28dd92963a4ed210cf9f3a0e43ded5ebe5dfd554f560b661f63cf2815d6fa3"
    sha256 cellar: :any,                 monterey:       "8b80a6c8cb6b0b7804023ec4089a5af967a04db86399f2d4bc9dcb5aef403517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7729f0d593f99eb96f24f24b141d8af4b466d01bd716adf7eb8bab6ab7437bb1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("buildliblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "includelibsais.h"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system ".test"
  end
end