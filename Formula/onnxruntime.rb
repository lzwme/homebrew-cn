class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.14.0",
      revision: "6ccaeddefa65ccac402a47fa4d9cad8229794bb2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6397a8110629a39dedfcea808fd83810e5c3f002ce6dc0130b243387949d019c"
    sha256 cellar: :any,                 arm64_monterey: "a3980307d3edcbd391db4e9bd7cd9171a36513634b0f379bf071ec60006e5dff"
    sha256 cellar: :any,                 arm64_big_sur:  "47d0d409c61af789911d9d2764eb9b48e2461ebd5bd3c8a6f4070a737f43d3d1"
    sha256 cellar: :any,                 ventura:        "a8bfecb8fb450bcd7b2cfd13fece6b1ecc27a5caa7712efcd5a9752f7627e3c4"
    sha256 cellar: :any,                 monterey:       "e923a799d0c4a5a747cb0c332a1d8f33990cd1d22e8ca4d43f3442826e4997f3"
    sha256 cellar: :any,                 big_sur:        "a063652bc9dd0de53ca104c9971a34d63c541c210e29800dcca17e5b19f3bc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1aa40cde3410bbcf749e4a61c206e29bf9b6a07c1cd70354f8f149ba6230be"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", "cmake", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <onnxruntime/core/session/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lonnxruntime", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end