class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https:github.commicrosoftonnxruntime"
  url "https:github.commicrosoftonnxruntime.git",
      tag:      "v1.16.3",
      revision: "2ac381c55397dffff327cc6efecf6f95a70f90a1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b06b639f3c6b38472e881ae695d51366087dbcf5465c29e1d472ec594693d63b"
    sha256 cellar: :any,                 arm64_ventura:  "73956bfb1672fc54d1d1a7eca4d2a6d13f38a6bc3bf313b1c9a1c80b04d28282"
    sha256 cellar: :any,                 arm64_monterey: "5ec63b8456d4d50a8a61ff4ffb860f464d626685474291a0ed6cc21ac4b6f55c"
    sha256 cellar: :any,                 sonoma:         "bf83e17fdf051cbb1acd9500ffb9df21e0b9752307690a481adb642630e0089e"
    sha256 cellar: :any,                 ventura:        "a3037644b90c34f15da55cf0befd1774684bf9de272387cc6719cafb5b383982"
    sha256 cellar: :any,                 monterey:       "c672337944b938b22e2b3774adb2e0f84324fb3f9e7c5a3a110172e10ba3d567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1829d4385c6eedfecb33611581fb33a81e1f276c549a0613f5cb792ed99e5c78"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", "cmake", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <onnxruntimeonnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath"test.c",
           "-L#{lib}", "-lonnxruntime", "-o", testpath"test"
    assert_equal version, shell_output(".test").strip
  end
end