class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.4.tar.gz"
  sha256 "fa1fb2aacaefd0a64728f301955a331ec08014db3adbf83c8848db8dc60be532"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "302f0a69dbb2fac2b1667876c3de0893f323adb6d07e23e0736b2c328d21c99a"
    sha256 cellar: :any,                 arm64_sonoma:  "3ebfdd966e633c15b78374659fa1af6b35fe2c957562d183f9e54fd5d65cefe1"
    sha256 cellar: :any,                 arm64_ventura: "a7c1867e860c0aca842b206b26b392ff9fa27c00adde7bb1f35cb6d26aa6a7b3"
    sha256 cellar: :any,                 sonoma:        "a031d1704de57368e8bc76b9fd2d910bdba812a92a950443bae1de860525d81d"
    sha256 cellar: :any,                 ventura:       "e9d4beb3cde4b5595aa66f43ca143e7d167636a7e0a6e6c6e53b06f77f69a038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40921f49ea69b6ffc1ea5c5843b8e696d5a45e11eb216459fa3aa6ebd6e8d5c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2nunstablecrl.h"

  def install
    system "cmake", "-S", ".", "-B", "buildstatic", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"

    system "cmake", "-S", ".", "-B", "buildshared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end