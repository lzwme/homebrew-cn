class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.13.tar.gz"
  sha256 "ea4b0ea3585be97bb31ced70ba6190f29ddefec32d102e47b2906d402ec4b8df"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19c6cddeb1676763fe39a5aee347c0d460ee730ca46e30ef6f10dfe95b890e39"
    sha256 cellar: :any,                 arm64_sonoma:  "892eae40e5cb9ac43d17f6b374a207308e3f36ceabc87e534f8e958cc50889af"
    sha256 cellar: :any,                 arm64_ventura: "1406af7df72b06c90807661b922c829cbad33ec3286fe7f880fc4e3088c9957f"
    sha256 cellar: :any,                 sonoma:        "60bd3e4143db09a54e063148a1bc0f458c9f513c2c0ca8a0ba2ea50375ab81d1"
    sha256 cellar: :any,                 ventura:       "72bb3edf8d5f80262a55cb3403a4cfcdc578aa1866e7d01fa4a69caad498536d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ab251f6c729d0fefeae2ce6c1407fb8254543ca003a15623752d5bb9901696"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
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