class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://ghfast.top/https://github.com/microsoft/onnxruntime/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "0f065cfd3816eaa4b709a057ea0e237ebc6463843af44a439e0d81af76d6620e"
  license "MIT"
  compatibility_version 7

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eecfd21aee16b6571dff54c214556b9dfd829f193bfc849b198420f2423c2320"
    sha256 cellar: :any, arm64_sequoia: "6d594052a82428bd0a31611c3b0e43ff13f68f27e6b3ffb15c97977e53f6d390"
    sha256 cellar: :any, arm64_sonoma:  "721944f91885205fe65b3310c897d8bab90939f45f12d19e246b57cb6a10094b"
    sha256 cellar: :any, sonoma:        "e0d7c2e0fa0cd5ce4b17ec94859122f7f3e6c5811cd0ccde036eef3ec20d4668"
    sha256 cellar: :any, arm64_linux:   "d46edbd82be7839f7ba4f4bc6c9ef5c27ae331a4906b930b2163c3cf1beef498"
    sha256 cellar: :any, x86_64_linux:  "ac951dbd3446ea27efad5a6e02cfe0edb15e5729bf1d5988a27a071d129d2756"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "eigen" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.14" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  resource "pytorch_cpuinfo" do
    url "https://ghfast.top/https://github.com/pytorch/cpuinfo/archive/4628dc060ce4e82345dc166bbac875609db4ff69.tar.gz"
    version "4628dc060ce4e82345dc166bbac875609db4ff69"
    sha256 "a550205e891f9f1982044a306cb54556347645cba129af34cd907160f83bd0f1"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^pytorch_cpuinfo;.*/(\h+)\.zip}i)
    end
  end

  resource "coremltools" do
    url "https://ghfast.top/https://github.com/apple/coremltools/archive/refs/tags/7.1.tar.gz"
    sha256 "d3222966982367b2be4ce62f1bd2b3dddc5a0ae018724a9acf850fbf2b0cc09a"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^coremltools;.*/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  resource "fp16" do
    url "https://ghfast.top/https://github.com/Maratyszcza/FP16/archive/0a92994d729ff76a58f692d3028ca1b64b145d91.tar.gz"
    version "0a92994d729ff76a58f692d3028ca1b64b145d91"
    sha256 "a91f4770ff9c39f4d72e339c379f566b3bbb359fa66122d85fc0bae3dde7abc7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^fp16;.*/(\h+)\.zip}i)
    end
  end

  resource "psimd" do
    url "https://ghfast.top/https://github.com/Maratyszcza/psimd/archive/072586a71b55b7f8c584153d223e95687148a900.tar.gz"
    version "072586a71b55b7f8c584153d223e95687148a900"
    sha256 "f6c4dab91ae9a03b3019e7cab0572743afd0e1b6e75b97fcca50259c737c924e"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/microsoft/onnxruntime/refs/tags/v#{LATEST_VERSION}/cmake/deps.txt"
      regex(%r{^psimd;.*/(\h+)\.zip}i)
    end
  end

  # Apply Fedora's workaround[^1] to allow `onnxruntime` to use `onnx` built without
  # ONNX_DISABLE_STATIC_REGISTRATION[^2]. We can't use this option as it will
  # break functionality for any dependents/users expecting the default behavior.
  # The main alternative is to build a bundled copy of `onnx`.
  #
  # [^1]: https://src.fedoraproject.org/rpms/onnxruntime/blob/rawhide/f/0013-onnx-onnxruntime-fix.patch
  # [^2]: https://github.com/microsoft/onnxruntime/issues/8556#issuecomment-1006091632
  patch :DATA

  def install
    python3 = which("python3.14")
    ENV.runtime_cpu_detection

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_MP11=#{formula_opt_prefix("boost")}
      -DPython_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{formula_opt_bin("protobuf")}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=OFF
    ]

    args << if OS.mac?
      "-Donnxruntime_USE_COREML=ON"
    else
      "-Donnxruntime_USE_COREML=OFF"
    end

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = formula_opt_bin("flatbuffers")/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Modified copy of upstream's testcase at
    # https://github.com/microsoft/onnxruntime/blob/main/onnxruntime/test/wasm/test_inference.cc
    (testpath/"test.cc").write <<~CPP
      // Copyright (c) Microsoft Corporation. All rights reserved.
      // Licensed under the MIT License.

      #include <cassert>
      #include <iostream>
      #include <onnxruntime/onnxruntime_cxx_api.h>
      #ifdef __APPLE__
      #include <Availability.h>
      #include <onnxruntime/coreml_provider_factory.h>
      #endif

      int main(void) {
        Ort::Env ort_env;
        Ort::SessionOptions so;
        #if defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 150000
        uint32_t coreml_flags = 0;
        Ort::ThrowOnError(OrtSessionOptionsAppendExecutionProvider_CoreML(so, coreml_flags));
        #endif
        Ort::Session session{ort_env, "mul_1.onnx", so};
        auto memory_info = Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU);

        std::array<float, 6> input_data{1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f};
        std::array<int64_t, 2> input_shape{3, 2};
        Ort::Value input_tensor = Ort::Value::CreateTensor<float>(memory_info,
                                                                  input_data.data(), input_data.size(),
                                                                  input_shape.data(), input_shape.size());

        std::array<float, 6> output_data{};
        std::array<int64_t, 2> output_shape{3, 2};
        Ort::Value output_tensor = Ort::Value::CreateTensor<float>(memory_info,
                                                                   output_data.data(), output_data.size(),
                                                                   output_shape.data(), output_shape.size());

        const char* input_names[] = {"X"};
        const char* output_names[] = {"Y"};

        session.Run(Ort::RunOptions{nullptr}, input_names, &input_tensor, 1, output_names, &output_tensor, 1);

        std::array<float, 6> expected_data{1.0f, 4.0f, 9.0f, 16.0f, 25.0f, 36.0f};
        std::vector<int64_t> expected_shape{3, 2};

        auto type_info = output_tensor.GetTensorTypeAndShapeInfo();
        assert(type_info.GetShape() == expected_shape);
        auto total_len = type_info.GetElementCount();
        assert(total_len == expected_data.size());

        float* result = output_tensor.GetTensorMutableData<float>();
        for (size_t i = 0; i != total_len; ++i) {
          assert(expected_data[i] == result[i]);
        }

        std::cout << Ort::GetVersionString();
        return 0;
      }
    CPP

    mul_1_onnx = "CAMSBmNoZW50YTpwChUKAVgKAVcSAVkaBW11bF8xIgNNdWwSCG11bCB0ZXN" \
                 "0KiMIAwgCEAEiGAAAgD8AAABAAABAQAAAgEAAAKBAAADAQEIBV1oTCgFYEg" \
                 "4KDAgBEggKAggDCgIIAmITCgFZEg4KDAgBEggKAggDCgIIAkIECgAQBw=="
    (testpath/"mul_1.onnx").write mul_1_onnx.unpack1("m")

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc", "-L#{lib}", "-lonnxruntime", "-o", "test"
    output_lines = shell_output("./test 2>&1").lines

    # Remove warning messages that are safe to ignore
    output_lines.reject! { |line| line["Skipping pci_bus_id for PCI path"] }
    assert_equal version.to_s, output_lines.join
  end
end

__END__
diff --git a/onnxruntime/core/session/onnxruntime_c_api.cc b/onnxruntime/core/session/onnxruntime_c_api.cc
index b60d97e38f..6951642edb 100644
--- a/onnxruntime/core/session/onnxruntime_c_api.cc
+++ b/onnxruntime/core/session/onnxruntime_c_api.cc
@@ -45,6 +45,8 @@
 #include "core/session/ort_env.h"
 #include "core/session/utils.h"
 
+#include "onnx/onnxruntime_fix.h"
+
 #if defined(USE_CUDA) || defined(USE_CUDA_PROVIDER_INTERFACE)
 #include "core/providers/cuda/cuda_provider_factory.h"
 #include "core/providers/cuda/cuda_execution_provider_info.h"
@@ -3094,6 +3096,13 @@ ORT_API(const char*, OrtApis::GetBuildInfoString) {
 }
 
 const OrtApiBase* ORT_API_CALL OrtGetApiBase(void) NO_EXCEPTION {
+  class RunONNXRuntimeFix {
+   public:
+    RunONNXRuntimeFix() {
+      onnx::ONNXRuntimeFix::disableStaticRegistration();
+    }
+  };
+  static RunONNXRuntimeFix runONNXRuntimeFix;
   return &ort_api_base;
 }