class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://ghproxy.com/https://github.com/DaveGamble/cJSON/archive/v1.7.16.tar.gz"
  sha256 "b0ca16e9f4c22b54482a3bfc14b64b50d8f2e305ee6014b0b3d3d9e700934f8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9066c6e3b3ecc6b392b07c5b7715ad96002caa8043ab86df2687ed9aea53a43"
    sha256 cellar: :any,                 arm64_monterey: "bdd5e577755439546f925fa35c5fb5e57e61c2045a39baad45df02b7bca921fc"
    sha256 cellar: :any,                 arm64_big_sur:  "76af3933a76bf52f90a76e13b2ff5d4a80eb801c1538318719db5a0e7f124b9a"
    sha256 cellar: :any,                 ventura:        "f0f22ae6788c5e1a6483276b7dc6dee4ea7088247a99e8063e5e18be86258485"
    sha256 cellar: :any,                 monterey:       "f3972082c2c41acf5f32c3174d70d61d138fb4ed2f9e7550a5ddbb9e27c1e3b7"
    sha256 cellar: :any,                 big_sur:        "83037536c9602abf998b5d936468b3b284c45232081096b6e56da9b3bfda4196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e4a3098f2597d4c02ee400458d92abf40f6d08f5c1474ec74e7afe3cce807ea"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CJSON_UTILS=ON",
                    "-DENABLE_CJSON_TEST=Off",
                    "-DBUILD_SHARED_AND_STATIC_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cjson/cJSON.h>

      int main()
      {
        char *s = "{\\"key\\":\\"value\\"}";
        cJSON *json = cJSON_Parse(s);
        if (!json) {
            return 1;
        }
        cJSON *item = cJSON_GetObjectItem(json, "key");
        if (!item) {
            return 1;
        }
        cJSON_Delete(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcjson", "-o", "test"
    system "./test"
  end
end