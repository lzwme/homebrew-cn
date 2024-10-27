class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.6.tar.gz"
  sha256 "85602d0ad672cb233052504624dec23b47fc6d324bb82bd6eaff13b8f652dec3"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "934853663eb867599419c9364f15910ebfd733f1b0919883debb7df2ac454e86"
    sha256 cellar: :any,                 arm64_sonoma:  "b63a221a50a1b0eb5efa252b896e4739552294ccaaaef78d0ffc3d97c57e3195"
    sha256 cellar: :any,                 arm64_ventura: "881cbc527129877b1e4bbad108d381dc0bdf6a7331dfd852333720eda8cbe890"
    sha256 cellar: :any,                 sonoma:        "b76b958ae455e893ad200829f4d101fd15e33fba9e6b3614968910a12dfcc651"
    sha256 cellar: :any,                 ventura:       "ac32502365adc6aaf3e23fb83a78fd846baf4b6382089418c39f0d1097965944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291bb15a9e04eda5d97d731e0282efbfee96b1a0b9a3140c84879ce2e3013f18"
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