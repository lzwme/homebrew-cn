class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.10.tar.gz"
  sha256 "6381d01183fd37be465c48bf85a86d36f1ee1b0b648753a6411474e4efe4109d"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1d3751c48b3a4fdf44fb04423cd88a7238d119fe666e7fd03ffcfda0611f67c"
    sha256 cellar: :any,                 arm64_ventura:  "9780ef0b252b580c516404d3e3e7d785d2da43966c6384c86e7be3d8b6dcc746"
    sha256 cellar: :any,                 arm64_monterey: "2e23642072bfedbe8702a4342e5ba5b2951cc41bc14c73308e65419d1490330b"
    sha256 cellar: :any,                 sonoma:         "a43668555427a907124567ec8244e9a2cc5698c66f3d677113eabeedc06209d5"
    sha256 cellar: :any,                 ventura:        "686e9391764497f20c2e68b60fd4f8462c1132de76da03e6e9192a48362a8859"
    sha256 cellar: :any,                 monterey:       "09bf8cca22de3204a4bb3c9c8c548cfbcd220ffef3023c62d32aecce80095bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ba32ccc5a0affbcffc701762685ccba0b09b77aefab592e3fe281e4367805b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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