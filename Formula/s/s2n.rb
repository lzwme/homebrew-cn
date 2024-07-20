class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.18.tar.gz"
  sha256 "a55b0b87eaaffc58bd44d90c5bf7903d11be816aa144296193e7d1a6bea5910e"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35063d09b64c6936dcf9f55cfb803e285fe386fbea357fce864a69f3c3d02d4b"
    sha256 cellar: :any,                 arm64_ventura:  "aa403d9c8887d4b68e0ee12bab3af7754785d25633cb911c698b3c63c2c17707"
    sha256 cellar: :any,                 arm64_monterey: "143e707d85b6e5e6a100e4ed7c16fcf5831f9fd5284042d67c43eebbfa3c9336"
    sha256 cellar: :any,                 sonoma:         "dd8d9497499555bc6cd6f7d49df73d4879a373d72f61c4042832ee47e1280695"
    sha256 cellar: :any,                 ventura:        "82b80606ca31f4b59e05487ce843daa5d86101ebd2c440a54c38645d56c90abe"
    sha256 cellar: :any,                 monterey:       "df13190048b876a6ebb7858fa8476b3f65cd811c1635966d0cf675765ab30d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb28ba3a01ea638a87297d7990da90db2c3141d932cbe21bf7afca15794d14df"
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