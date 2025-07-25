class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.23.tar.gz"
  sha256 "81961ea5ae9313c987edfa579306ad4500bedfbf10caf84d8a5dcfc42aaf591f"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "934ec28b19a204d7d2333a0856170141972a9d6c460d068f76130c1d1971c93d"
    sha256 cellar: :any,                 arm64_sonoma:  "617e270f81c8326fde776e4906164caf9b05e398c554a9ba49f29877573e7728"
    sha256 cellar: :any,                 arm64_ventura: "0068665ad5a174d91d7b91544d4338bd7b206ecac2101616cc218fdfeb0dc29d"
    sha256 cellar: :any,                 sonoma:        "d3d8be230226fc065de8686b492448c8038a15a5c419a202172314e3e7915363"
    sha256 cellar: :any,                 ventura:       "3baf3afd9863e267564d9c2731074bf02d8ad3781e7b40340c5473f4335d08f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb7504893622835d724ad8a778c03d0c30d1c653ddd7cb4fa968d003af66f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e6e116b08b6d013c0972c8c27502fe5074b0dfb66f9e389dddfb5a69f2fdc56"
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
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end