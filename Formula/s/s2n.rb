class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.1.tar.gz"
  sha256 "d79710d6ef089097a3b84fc1e5cec2f08d1ec46e93b1d400df59fcfc859e15a3"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a098c9c60b0902dd52f1ccd00be745acd712328cade8b55772fd90f1e84516ce"
    sha256 cellar: :any,                 arm64_ventura:  "2bdc7cb808376e920808a52026eb16c820315f1f086ff3830addce9d76194920"
    sha256 cellar: :any,                 arm64_monterey: "1e025ecbc0532b35b4c126c092b89056fb065f37c2e1615ba1aecb0f873f459b"
    sha256 cellar: :any,                 sonoma:         "141f9c2eb073ca7be650c9918cf4cd7dd45629e3602d22c376075f739b9d2db9"
    sha256 cellar: :any,                 ventura:        "fcc933ab0d1e28e6d69fdaa7ca8e85edd6ceb7dccfda13df4a384694c88ef6ef"
    sha256 cellar: :any,                 monterey:       "a695a15f45ffada1b8207e10f3cd15e7f90deca28df7be77560544fbec452d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc18bca6c565d2dfd65c45c18a916c6667930d60f45e53f89abd9e96cef5a1f"
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