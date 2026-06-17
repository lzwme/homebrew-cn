class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://ghfast.top/https://github.com/benmcollins/libjwt/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "dfb86291a92c3e6373b71164dad7d15ae5c62f90d24b81abf2fe2395ba3057b5"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b396a35b9c3b2bc6ab8c19bcbe085a4fbbf76fadfb4e79bc9ef60bb4aa00a976"
    sha256 cellar: :any, arm64_sequoia: "fcb429230dd6b6ce04c7ff05cd781bee4baf28cb7ef1a810b16922fd9774b65a"
    sha256 cellar: :any, arm64_sonoma:  "5078fde701cc620106ff60da5ebba647dfafb3c9db7d17ef48d37d4378f42e50"
    sha256 cellar: :any, sonoma:        "16bed1e537fb1795a9f3ef9afb45423ae674d6dfbf4c719921f25d7a3dcbad66"
    sha256 cellar: :any, arm64_linux:   "d2c258f5912da1471399dfdd36cbec692265d65fbe6ea183b7d59628d26e9903"
    sha256 cellar: :any, x86_64_linux:  "e39b6f496729cbbd9b6e3be80c2a16e21ec3cac1754d6c2906c0895aaa379a6a"
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