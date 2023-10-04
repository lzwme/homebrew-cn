class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/v1.3.52.tar.gz"
  sha256 "c8ae02ae427763dcffe10d211ed7a2433803affd9aa5836951ef972c53db0120"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c147c1e3d0ae612fc40d1775c2d3afbadc6fed2517b1f9b263861a4e924e1df"
    sha256 cellar: :any,                 arm64_ventura:  "726eca2900f007d2a125815d417241f63a34d071a488d9937b5ec7412a761083"
    sha256 cellar: :any,                 arm64_monterey: "f864dd213299c8bcdf1a1ce674123363a0823bd52ef86b202dc21a0070709355"
    sha256 cellar: :any,                 sonoma:         "44c1931ed762973e13264ffb9b481fadf12c96415163779947cd4103c1242e97"
    sha256 cellar: :any,                 ventura:        "826d24aa0feeb069d038d1c07954fb6b7b4962534a254dc68243fb95c52a97b3"
    sha256 cellar: :any,                 monterey:       "18f0f47447e0a404fea7faa3b558777b3e07cbb80c66ee4ec8ed38de2334dc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6a8180c3757f4ca8241cb8b0a44cf778f17a80c4704e3eef2f4572ebeb9716d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end