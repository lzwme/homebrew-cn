class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.2.tar.gz"
  sha256 "65d452d62119000c8056c569a0fe5bcbd261c464c41c945a8244df2e89855af8"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b95ae97559bdd60da1de492ea1aa1553ea8426daba435090bd76576a7733d4d"
    sha256 cellar: :any,                 arm64_ventura:  "3516a4d87003c492598a3f38ef8707c170e80893f528982c9fc4fee6210cdb4f"
    sha256 cellar: :any,                 arm64_monterey: "13f2d4928006fc6af51ea65d7d1ae556dcb6c5ba3e6148ed7dd5d76574318cfb"
    sha256 cellar: :any,                 sonoma:         "0362f67e8c1be75d369f2da1bd98e4b97ed3024621fddd9b44df65698c28c563"
    sha256 cellar: :any,                 ventura:        "3044720df74fc695a10e47f9088aca59152b7b1006c727cd5028a61efe8b0281"
    sha256 cellar: :any,                 monterey:       "4f042bdb91745e18531b4cfffd2b499e3df6da3e3d02a673ff9508b1cf0b7bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7bb3429ad34282d24efbbc47260ebd35472a664e1cffe65e1dd29e6bd544e4"
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