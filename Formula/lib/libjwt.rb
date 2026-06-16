class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://ghfast.top/https://github.com/benmcollins/libjwt/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "4f5e41f49e51c3dea781218ad298e07083804c72a84186bf1a61e1a3c5211537"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49eceb5a3d3965c1c52f481ea0fa7d6d4685017fc24ca64fad5050193026ba08"
    sha256 cellar: :any, arm64_sequoia: "04c63b5ffed09889457e1d55027b6418899af83949c11de1f8e14889fb9c38d0"
    sha256 cellar: :any, arm64_sonoma:  "4178d96692e747acfcae13ad4f2c8883d7749b1acf1f0f97dccd4879c42ef867"
    sha256 cellar: :any, sonoma:        "f3ad4317d4779b8f2519d7d4cb2f11feb0ee2e5edcf815890ab0ae5fa7fed961"
    sha256 cellar: :any, arm64_linux:   "c41bd9550a9ac4f9008c0f59609653220d3bbda4785f80c4e397a784d6c6bbf5"
    sha256 cellar: :any, x86_64_linux:  "a120ea74da7590c0b7def42a8d6f6f10ac4895206252fc447085442f9fbb6402"
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
    (testpath/"test.c").write <<~C
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
    system "./test"
  end
end