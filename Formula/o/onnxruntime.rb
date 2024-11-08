class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https:github.commicrosoftonnxruntime"
  url "https:github.commicrosoftonnxruntime.git",
      tag:      "v1.20.0",
      revision: "c4fb724e810bb496165b9015c77f402727392933"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89afd3b53934d9f0a30347a77ade4125439dd36100a5963042b8ec887166d84f"
    sha256 cellar: :any,                 arm64_sonoma:  "d2ff2da6a74099a7f9feb7bbd7eefe5ae8d85cae62c84b619d4f5f677e9ffeec"
    sha256 cellar: :any,                 arm64_ventura: "1067d78cfd1733723cb9d8311c5001bca0850d31df5980bd4e99a3219b5dd006"
    sha256 cellar: :any,                 sonoma:        "397d5caa78399e71a210e9a28d785b904fe8c8f6d2f2bf71eaed0bc43091ff93"
    sha256 cellar: :any,                 ventura:       "889cd506031e2db70625859623edd40b88157735e73fccba5d7336bdc10f2f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25d31a6f9ea4d9e895e3da3ec523387179274f6b021777301acc87d35ba4cf5"
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
  depends_on "protobuf@21" # https:github.commicrosoftonnxruntimeissues21308
  depends_on "re2"

  # Need newer than stable `eigen` after https:github.commicrosoftonnxruntimepull21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  #
  # https:github.commicrosoftonnxruntimeblobv#{version}cmakedeps.txt#L25
  resource "eigen" do
    url "https:gitlab.comlibeigeneigen-archivee7248b26a1ed53fa030c5c459f7ea095dfd276aceigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.tar.bz2"
    sha256 "a3f1724de1dc7e7f74fbcc206ffcaeba27fd89b37dc71f9c31e505634d0c1634"
  end

  # https:github.commicrosoftonnxruntimeblobv#{version}cmakedeps.txt#L52
  resource "pytorch_cpuinfo" do
    url "https:github.compytorchcpuinfoarchiveca678952a9a8eaa6de112d154e8e104b22f9ab3f.tar.gz"
    sha256 "c8f43b307fa7d911d88fec05448161eb1949c3fc0cb62f3a7a2c61928cdf2e9b"
  end

  # TODO: Consider making separate formula
  resource "onnx" do
    url "https:github.comonnxonnxarchiverefstagsv1.17.0.tar.gz"
    sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  end

  # Fix build on Linux
  # TODO: Upstream if it works
  patch :DATA

  def install
    python3 = which("python3.13")

    # Workaround to use brew `nsync`. Remove in future release with
    # https:github.commicrosoftonnxruntimecommit88676e62b966add2cc144a4e7d8ae1dbda1148e8
    inreplace "cmakeexternalonnxruntime_external_deps.cmake" do |s|
      s.gsub!( NAMES nsync unofficial-nsync$, " NAMES nsync_cpp")
      s.gsub!(\bunofficial::nsync::nsync_cpp\b, "nsync_cpp")
    end

    resources.each do |r|
      (buildpath"build_deps#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}build_depspytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf@21"].opt_bin}protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin"flatc"
    system python3, "onnxruntimecoreflatbuffersschemacompile_schema.py", "--flatc", flatc
    system python3, "onnxruntimeloraadapter_formatcompile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <onnxruntimeonnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output(".test").strip
  end
end

__END__
diff --git aonnxruntimecoreoptimizertranspose_optimizationonnx_transpose_optimization.cc bonnxruntimecoreoptimizertranspose_optimizationonnx_transpose_optimization.cc
index 470838d36e..81a842eb87 100644
--- aonnxruntimecoreoptimizertranspose_optimizationonnx_transpose_optimization.cc
+++ bonnxruntimecoreoptimizertranspose_optimizationonnx_transpose_optimization.cc
@@ -5,6 +5,7 @@
 
 #include <algorithm>
 #include <cassert>
+#include <cstring>
 #include <iostream>
 #include <memory>
 #include <unordered_map>