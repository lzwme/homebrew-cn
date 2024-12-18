class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.10.tar.gz"
  sha256 "6f13d37658954cc24f4eb8c7f30736e026ce06f8c9609f7820ab82504618a98d"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d688330a8c1f4de97d36ff70ac4784d5f732dd7cbb0ce5c134dcf52d084a1c65"
    sha256 cellar: :any,                 arm64_sonoma:  "2445f1fdcd1d6d180e7f2bf7996575421fc082594f3eeb1066b00e7e7a97bfb1"
    sha256 cellar: :any,                 arm64_ventura: "573323b2b7c385d699d7160ec3da6f60f22f8d31b4c76d9169774dd76ed430d3"
    sha256 cellar: :any,                 sonoma:        "fae454a2b307ff20a7facb2e1309eb20759d43844927a8f90ecd5f973120225c"
    sha256 cellar: :any,                 ventura:       "f600a145873d4978a3e3302f430321cef9c489b40f0ef183c6f33c22f147dca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e6a035b848cb61cd0e30d656f16bb03ad2b9c8748bd9b61fb4310082149369"
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
    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end