class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.19.tar.gz"
  sha256 "d8f2ffe11c4e5827ae6b35288849a0e4e8c17dedf7f982f4c05e5df868feb957"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08fb9bc22072aefae8a8e90872e2229c791f66841955495f3794b6444e2d2f41"
    sha256 cellar: :any,                 arm64_ventura:  "cd25fa7b857badc16482e684641bf10c53c91de0fa9dd053a0bdfe26249e9ae9"
    sha256 cellar: :any,                 arm64_monterey: "df55b9064d388674fef35d71996f19581e3f8b3cb9233ce82be0970218d7cf20"
    sha256 cellar: :any,                 sonoma:         "d03ae43cfa23f12bb251f8f91be76762095d57d6b07f4de6fc66375ac2393a23"
    sha256 cellar: :any,                 ventura:        "6dbb820bf83e8130b81cc22297f361272b4bff12103dc34ae9d66d6d866a0bff"
    sha256 cellar: :any,                 monterey:       "11cb7de4624d012b8ebfd1613c3934473098f244827711fd7bf26fd27f459400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051acd1cb292179b65b52a6c1861146552fcf0a1cfc6c61c85df21277a066e04"
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