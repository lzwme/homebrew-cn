class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.16.1",
      revision: "2a1fd2586ff9ea7b2af94a7d4b1b3c124f5f3cda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc3f85016e2105dcbd98f6f674eff2824f929f1ed9c507158bfe49e8c8ef6d91"
    sha256 cellar: :any,                 arm64_ventura:  "634b4c28663308cb0df6091021b4f1556b518d6bb8f08723b2076d3e38cbf80e"
    sha256 cellar: :any,                 arm64_monterey: "169e7c325c1a935e6cd5064b057bea8646bd3deb688efe471f8e3b0fcb093fdb"
    sha256 cellar: :any,                 sonoma:         "ea6d66d0c6e8b77807376dada255d40ef13d876ac6c3d978c6b729a391e0f75a"
    sha256 cellar: :any,                 ventura:        "5419fe87990cc5d325c0bd8811f1164df88fd86d60f6a50332d5dece31a62f31"
    sha256 cellar: :any,                 monterey:       "070dea6533e2034d668b49f35739c4981e2a16c191a054e8bd7dd6eb6c26797b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa0b88368cf8bea5872ba1ef679368822618381d5f0586c254c7626a0dfb9fb"
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
      #include <onnxruntime/onnxruntime_c_api.h>
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