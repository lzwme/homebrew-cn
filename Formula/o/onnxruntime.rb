class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.16.2",
      revision: "0c5b95fc86750526d09ee9e669a98506116c6bde"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b35414f88648d1c36683b3688df27fecfc5e68071fea2cb63abf2639f41f025e"
    sha256 cellar: :any,                 arm64_ventura:  "826c2622e6b75e4cbdc82f1a22db36c69cf5b77346d6eb244726e2dd8d731655"
    sha256 cellar: :any,                 arm64_monterey: "662cbdbb4e73da551da210bbcf1d24189df9fdde7f6e8548bf46c833a78fddec"
    sha256 cellar: :any,                 sonoma:         "9834a7b77566051fba6d10b371320e1fafd5cc5e97091ef35922c84e926a767a"
    sha256 cellar: :any,                 ventura:        "12443e8f48d22c847bf253eb8a43e107c973fc3d9a15dc02f2bc8af0e2e93920"
    sha256 cellar: :any,                 monterey:       "2f59e83f0159548a97b88d2e3571566ee52cb322b494efa6baaa03eab3671feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f0a4125d1e192b9ae910810518862cf54c3287ae538b4872616d9bc59637ee"
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