class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.22.2",
      revision: "5630b081cd25e4eccc7516a652ff956e51676794"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b6ce4e40bc872d41b3465087f33368be529d012837ee39e623c3f1945687a965"
    sha256 cellar: :any,                 arm64_sonoma:  "dd9b51559f0018475fcd0e6c69c5b04cd16196344349d7eea66dbc716b8446ea"
    sha256 cellar: :any,                 arm64_ventura: "429c0123c23cf2cac3b027ad0063689f9420370c7509951c26f6993b12666485"
    sha256 cellar: :any,                 sonoma:        "4ec256f4208ebf915fdbc3629fece4cdd50168eca52bbdbd325f8d9b35b20d96"
    sha256 cellar: :any,                 ventura:       "c0aa9cbe0254bceeb4e7d075870fe3804bdbd4d2ef6568f5300fd3b2effec8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8386275b57e59ee756726ff8ece631847cda5f8033a1331083e8ecc23737630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531739b8bdcf50b4b663906499cc37f0bea8b5f8a732cf19c35bd1490939ba1d"
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

  # Workaround for Abseil >= 20250814.0 which removed absl::low_level_hash[^1].
  # Upstream only supports using vendored deps which we bypass.
  # [^1]: https://github.com/abseil/abseil-cpp/commit/2ea5334068f11664a71d1d9dfb9a475482fa05f5
  patch :DATA

  def install
    python3 = which("python3.13")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPython_EXECUTABLE=#{python3}
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

__END__
diff --git a/cmake/external/abseil-cpp.cmake b/cmake/external/abseil-cpp.cmake
index 427e77a524..feb2eb26f1 100644
--- a/cmake/external/abseil-cpp.cmake
+++ b/cmake/external/abseil-cpp.cmake
@@ -119,7 +119,6 @@ absl::absl_check
 absl::hash_function_defaults
 absl::function_ref
 absl::city
-absl::low_level_hash
 absl::fixed_array
 absl::variant
 absl::meta