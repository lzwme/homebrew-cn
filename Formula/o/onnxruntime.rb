class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.22.2",
      revision: "5630b081cd25e4eccc7516a652ff956e51676794"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6bedfb945c57cc8a9dd11c99d8e47e7b85e718ab093631542e51db18a4d9e7bd"
    sha256 cellar: :any,                 arm64_sonoma:  "b185d68f6a9a8f54b1494033aa29168c28e535db7fb505aeea32436b5421f947"
    sha256 cellar: :any,                 arm64_ventura: "a57277224f432168c8ebf69606a10a263477bbd6b76c577eea3c392a904eef2c"
    sha256 cellar: :any,                 sonoma:        "2a3b68b083bc2cd382b56fddbc4c12aa47b0449890b031b898612d7c3e1752d4"
    sha256 cellar: :any,                 ventura:       "de69624b84883e1462ebabd86b22b6795dde45559180945ecc2a32b22d57b965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9a22cfecd23575734b13b65b7340eab31bd90919fa72293995dc783c59f3a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bdff223832e7f4689cec5aadb718ba78ef2e7af4c7fca74e64828e725e67b06"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.13" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "nsync"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  # Need newer than stable `eigen` after https://github.com/microsoft/onnxruntime/pull/21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  resource "eigen3" do
    url "https://gitlab.com/libeigen/eigen/-/archive/1d8b82b0740839c0de7f1242a3585e3390ff5f33/eigen-1d8b82b0740839c0de7f1242a3585e3390ff5f33.tar.bz2"
    version "1d8b82b0740839c0de7f1242a3585e3390ff5f33"
    sha256 "37c2385d5b18471d46ac8c971ce9cf6a5a25d30112f5e4a2761a18c968faa202"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^eigen;.*/eigen[._-](\h+)\.zip}i)
    end
  end

  resource "pytorch_cpuinfo" do
    url "https://ghfast.top/https://github.com/pytorch/cpuinfo/archive/8a1772a0c5c447df2d18edf33ec4603a8c9c04a6.tar.gz"
    version "8a1772a0c5c447df2d18edf33ec4603a8c9c04a6"
    sha256 "37bb2fd2d1e87102baea8d131a0c550c4ceff5a12fba61faeb1bff63868155f1"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^pytorch_cpuinfo;.*/(\h+)\.zip}i)
    end
  end

  def install
    python3 = which("python3.13")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}/build/_deps/pytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf"].opt_bin}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <onnxruntime/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end