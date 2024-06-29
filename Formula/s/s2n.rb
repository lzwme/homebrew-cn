class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.17.tar.gz"
  sha256 "5235cd2c926b89ae795b1e6b5158dce598c9e79120208b4bcd8d19ce04d86986"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad2bc7734d8fbb18075790621a3781056f13ecfb12f8737806595356afb38625"
    sha256 cellar: :any,                 arm64_ventura:  "b2453542473f3ed85edd7cceed86a4e98ec39ee62e1909987f531b05ed60b0de"
    sha256 cellar: :any,                 arm64_monterey: "ab6a226c1cecd77c81113fc2b232588d24b866096e660372a72fd673d8198ed4"
    sha256 cellar: :any,                 sonoma:         "fd2e1a5d4278768018d7ed0b7870dd2c6293acb604c74e37305f90dec9c74379"
    sha256 cellar: :any,                 ventura:        "35268253905056f4749d5d7c9536b335f36397eeba00552e9583af799dc73617"
    sha256 cellar: :any,                 monterey:       "259364de44326f0483a3672e02d16dfd4b640829a7ded4d41a21b726c53353e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6726a2a01320c16595ea9d1014e72a48ebec3ed14d32d1058633b2ba0f5c01d3"
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