class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.7.tar.gz"
  sha256 "c30b97c8bcccc0557331dd1a043010a70984c9cff11b0bbd769651db68f8b91d"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79f6891a6b7bca21cce0feeff6990c81528b29d5e6a087f811503a0e20e6f952"
    sha256 cellar: :any,                 arm64_sonoma:  "1077b62d0147a10d7928afaaaf4361f9b5a90c340d8e00e4a137137c4430919c"
    sha256 cellar: :any,                 arm64_ventura: "a1390eebaf9c03570367af7847039612279e2f092961002309e56a818c11789a"
    sha256 cellar: :any,                 sonoma:        "3993a1af13b29ecda565b824db709046adc6d03aafd87e48b4dd413fef5474fd"
    sha256 cellar: :any,                 ventura:       "d154c42cde51325a86f85309f2d0c8423d8cbfc4fda5671b05acece544226417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21683821ff23e7fc1a22a5f12fb3c4652ccb8d0792dd7252f2aac5a09c9e8e5f"
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