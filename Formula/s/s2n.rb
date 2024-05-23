class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.15.tar.gz"
  sha256 "e1a258247714c0887f38c8438e162f54947eab78dc81f841ec7e9c90402a71d0"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eaffe52d69e9c63a84683c023dd0b292647cf9eca9e0461d50de76822e000b31"
    sha256 cellar: :any,                 arm64_ventura:  "8b29d14cc7e94c525f453d5664cbbf8d8252373d7c78cb4eb25d5de0debfe036"
    sha256 cellar: :any,                 arm64_monterey: "887baf2e39a6aa4156a25cfc00e13e1fe82214fd0b299a245d0815e2ce9149fe"
    sha256 cellar: :any,                 sonoma:         "8e49d36b2e862180439bc25a32a6fffe40d775f2bd738448f593411ebe8a2ea9"
    sha256 cellar: :any,                 ventura:        "d4b39c831df6d933745bbfa05eca6e1e082a89c4d9f837ce50366741b8156c78"
    sha256 cellar: :any,                 monterey:       "ede194469630f3a5e8fc99d1d22c3681528aa8304597248108f7ff4d7dac6299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22fbbd388b76f05500e14821402d3d0abfd59f7223039c4905cc46357b58e670"
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