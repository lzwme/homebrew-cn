class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.15.tar.gz"
  sha256 "103f9361c736fea7278038891b0566ff975c40ac59cef5ac5b9225a476c8abc6"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b566c028c81a7f1bf06c82f037600ed29e1c0207fee988636c5710d43de1a81d"
    sha256 cellar: :any,                 arm64_sonoma:  "d570f110552aec768bbd498cd05ed68abb7c1f07d7428a138c59e9a039b4700d"
    sha256 cellar: :any,                 arm64_ventura: "ec81383e60a6202a04404dc3d5b9b3134edd5a77dabbaf9e822bed24382aefd4"
    sha256 cellar: :any,                 sonoma:        "a1dc453246e53fa3305dd0c81a3f79b74ba5418f14332374abd17d62940f0ce2"
    sha256 cellar: :any,                 ventura:       "e8e1d2e869240157dd2302361cf988c3921b17d6579e529b5c9eb6edf7cc2adb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691faf41781948129689e1647a85d3b87c3a46586ffb288ae6840be6bb4cc0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8217e04f229e4762ff681291b005c233bdd2b6f1d5759cfacb7847966a9dcc6c"
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