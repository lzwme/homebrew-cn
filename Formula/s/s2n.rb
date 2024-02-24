class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.5.tar.gz"
  sha256 "0914f59a6d458d2fb726f172a4d05d036822ed41feb7763cd37fccf6aa3c58b2"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d91b50d9d92e0af3bcd9d3c03dd93958696cdbe07460b9ac0af8f835e5c6989a"
    sha256 cellar: :any,                 arm64_ventura:  "f2bef1cbe64faff9d1310e001c5b305f9460a73b6db99c73441bbf8fee11089a"
    sha256 cellar: :any,                 arm64_monterey: "27c435ebd32185dd08f33b27196f171d72c54d5341ce14f3a66eca3f8b5a09b6"
    sha256 cellar: :any,                 sonoma:         "1b759cd650757bca5661ddf1e32cbc76283f43cc6533fdcd4ab582469fbaa3b9"
    sha256 cellar: :any,                 ventura:        "750d33b6ecd88bdaffe90421222b2d1e293d5900ff9488e3168f5b5689ec0be6"
    sha256 cellar: :any,                 monterey:       "1d3df6823465baba6bf0f831cbee3767001bec2c04bb097ea981f6307c741068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e13aa5f529a65339b9768751fa522ec42f19ae5aed11839668a74feecf82dc"
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