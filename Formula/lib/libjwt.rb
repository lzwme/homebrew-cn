class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https:libjwt.io"
  url "https:github.combenmcollinslibjwtreleasesdownloadv3.2.0libjwt-3.2.0.tar.xz"
  sha256 "17ee4e25adfbb91003946af967ff04068a5c93d6b51ad7ad892f1441736b71b9"
  license "MPL-2.0"
  head "https:github.combenmcollinslibjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d4f3d28567daf4a427ff7d98aafa1a812e917159bf5da992a68d9c5cbde3402"
    sha256 cellar: :any,                 arm64_sonoma:  "a7af31abe96a7a3f1cca4508376e19471783bfee1729749eed6476f0aa7305a6"
    sha256 cellar: :any,                 arm64_ventura: "96f02b4299ca14c11385c2cf9700f6938d415c4ac304e087199c2a7608003280"
    sha256 cellar: :any,                 sonoma:        "f2099c80842a0edd9655d3e2f4cb255f3d94d963a957c5f830f0ddf1c80b0082"
    sha256 cellar: :any,                 ventura:       "317b411b882679040c72d2d62d42fb86c706111650386689df2e9a75495f5f20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00666188d1844cb30a4452cf56019360a425d6aace69199d1a5bca0cdc5572a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1defb719e07be7e05546b3512320ba7b01cd015ac71063d89e3c609747911b31"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main(void) {
        jwt_builder_t *builder = jwt_builder_new();
        char *token = jwt_builder_generate(builder);
        free(token);
        jwt_builder_free(builder);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system ".test"
  end
end