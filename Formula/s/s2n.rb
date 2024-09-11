class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.2.tar.gz"
  sha256 "896d9f8f8e9bd2fdcb9a21b18aede4f7afc65bde279afabc60abf97fa5069dd1"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "aca86e4b05c07f4b72442d44855bb218b33ccec54378533212d66eb25c5e1d29"
    sha256 cellar: :any,                 arm64_sonoma:   "c7d7d4c5d9343ab609bfcfc815016e33e673c6c9e632cdb782fa06a92d9bb9c5"
    sha256 cellar: :any,                 arm64_ventura:  "f8b7b10b87e43d89826a24ea3eda969203f7c0f3bc3b0e57334bfcbe5373eed6"
    sha256 cellar: :any,                 arm64_monterey: "41ad9e378aed4c67862f327938300bad411b0fe5a438fa9374dcfe58b5c70151"
    sha256 cellar: :any,                 sonoma:         "45b94c13f999f30dbf14d87f7ceac3ed6394eb9be353b032d79d5114615bca91"
    sha256 cellar: :any,                 ventura:        "c4cbc28b325a40222246182306b11a715d547de41203241a999c9351f567099e"
    sha256 cellar: :any,                 monterey:       "643a1c0a834c369e8d5f1ff60d44955fa372eeeccbf9a4beb47e5359ce116d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8a6013e9ba8316d7d6e60af9d242df02ee99c6f81141ac36e94f2866aa00ce"
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