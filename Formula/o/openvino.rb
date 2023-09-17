class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://ghproxy.com/https://github.com/openvinotoolkit/openvino/archive/refs/tags/2023.0.2.tar.gz"
  sha256 "7f09b795f9261e9dc4a49eeec572a07910f90702142ad4ae164ddf214edaa9d4"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73d3db793fa998277e711e984ce8aaf3cc4790a7bffa9db1e982fa7f7d28512b"
    sha256 cellar: :any,                 arm64_monterey: "78c13dd2346ffe5ffad1736362f3018ea369c3516e23d324bfbd88b9e6e26128"
    sha256 cellar: :any,                 arm64_big_sur:  "c5eb01724c49f721cbac731620406931f8a92a02ed52ad6c97235f36043be951"
    sha256 cellar: :any,                 sonoma:         "ff2296aff5db0fe0299624e5f39a1d90f4feec374fc82f865f5c3ccbb219755c"
    sha256 cellar: :any,                 ventura:        "277344455f4b6831652eff6b2fbb548aa73f47c53e6355f781a5662a4dfd3df6"
    sha256 cellar: :any,                 monterey:       "43d3286be8e49e4d0496aa7507636df889e5b8673652197f84783d42716ea3ca"
    sha256 cellar: :any,                 big_sur:        "6dab795991e287d5cb1d1e6598980f1bb4b747f9d4a2e8a1c492bd928217d675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9b284861ea8ff4f4717d56e77e904facb364dbae301c742dd145ab1365ac58"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "python@3.11" => :build
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://ghproxy.com/https://github.com/oneapi-src/oneDNN/archive/f27dedbfc093f51032a4580198bb80579440dc15.tar.gz"
      sha256 "da57c2298a8e001718902f0b65b6d92c4a7897b35467e23bc24996dde43ec47b"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://ghproxy.com/https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v23.02.1.tar.gz"
      sha256 "c3a443e26539f866969242e690cf0651ef629149741ee18732f954c734da6763"
    end
  end

  on_intel do
    depends_on "xbyak" => :build
  end

  resource "ade" do
    url "https://ghproxy.com/https://github.com/opencv/ade/archive/refs/tags/v0.1.1f.tar.gz"
    sha256 "c316680efbb5dd3ac4e10bb8cea345cf26a6a25ebc22418f8f0b8ca931a550e9"
  end

  resource "onednn_cpu" do
    url "https://ghproxy.com/https://github.com/openvinotoolkit/oneDNN/archive/1c7bfabf1b26e6fb95fea1613e1d3d2bef1f6b54.tar.gz"
    sha256 "52921b3efab33d1710971c67318e8c00ee102b6369e4e9cea8fdf91a1d68e38e"
  end

  resource "onnx" do
    url "https://ghproxy.com/https://github.com/onnx/onnx/archive/refs/tags/v1.13.1.tar.gz"
    sha256 "090d3e10ec662a98a2a72f1bf053f793efc645824f0d4b779e0ce47468a0890e"
  end

  # Fix build with static protobuf from brew (https://github.com/openvinotoolkit/openvino/pull/19590)
  # Remove patch when available in release.
  patch do
    url "https://github.com/openvinotoolkit/openvino/commit/6fbcb94e202fd1036f674a7f00b5c03ffdc8132a.patch?full_index=1"
    sha256 "065ba52a2e74516ddcc51184d30c51c76ab2e6f9bfede03900641ca1bfda7761"
  end

  def install
    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdparty/ade thirdparty/ocl
                      thirdparty/xbyak thirdparty/gflags
                      thirdparty/ittapi thirdparty/snappy
                      thirdparty/pugixml thirdparty/protobuf
                      thirdparty/onnx/onnx thirdparty/flatbuffers
                      src/plugins/intel_cpu/thirdparty/onednn
                      src/plugins/intel_gpu/thirdparty/onednn_gpu
                      src/plugins/intel_cpu/thirdparty/ComputeLibrary]
    dependencies.each { |d| (buildpath/d).rmtree }

    resource("ade").stage buildpath/"thirdparty/ade"
    resource("onnx").stage buildpath/"thirdparty/onnx/onnx"
    resource("onednn_cpu").stage buildpath/"src/plugins/intel_cpu/thirdparty/onednn"

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath/"src/plugins/intel_cpu/thirdparty/ComputeLibrary"
    elsif OS.linux?
      resource("onednn_gpu").stage buildpath/"src/plugins/intel_gpu/thirdparty/onednn_gpu"
    end

    cmake_args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_GNA=OFF
      -DENABLE_PYTHON=OFF
      -DENABLE_SAMPLES=OFF
      -DENABLE_COMPILE_TOOL=OFF
      -DCPACK_GENERATOR=BREW
      -DENABLE_SYSTEM_PUGIXML=ON
      -DENABLE_SYSTEM_TBB=ON
      -DENABLE_SYSTEM_PROTOBUF=ON
      -DENABLE_SYSTEM_FLATBUFFERS=ON
      -DENABLE_SYSTEM_SNAPPY=ON
    ]

    system "cmake", "-S", buildpath.to_s, "-B", "#{buildpath}/openvino_build", *cmake_args
    system "cmake", "--build", "#{buildpath}/openvino_build"

    # install only required components

    components = %w[core core_dev
                    cpu gpu batch multi hetero
                    ir onnx paddle pytorch tensorflow tensorflow_lite]
    components.each { |comp| system "cmake", "--install", "#{buildpath}/openvino_build", "--component", comp }
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs openvino").chomp.split

    (testpath/"openvino_available_devices.c").write <<~EOS
      #include <openvino/c/openvino.h>

      #define OV_CALL(statement) \
          if ((statement) != 0) \
              return 1;

      int main() {
          ov_core_t* core = NULL;
          char* ret = NULL;
          OV_CALL(ov_core_create(&core));
          OV_CALL(ov_core_get_property(core, "CPU", "AVAILABLE_DEVICES", &ret));
      #ifndef __APPLE__
          OV_CALL(ov_core_get_property(core, "GPU", "AVAILABLE_DEVICES", &ret));
      #endif
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_METRICS", &ret));
          ov_core_free(core);
          return 0;
      }
    EOS
    system ENV.cc, "#{testpath}/openvino_available_devices.c", *pkg_config_flags,
                   "-o", "#{testpath}/openvino_devices_test"
    system "#{testpath}/openvino_devices_test"

    (testpath/"openvino_available_frontends.cpp").write <<~EOS
      #include <openvino/frontend/manager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    EOS

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}/openvino_frontends_test").strip
  end
end