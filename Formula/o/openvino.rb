class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https:docs.openvino.ai"
  url "https:github.comopenvinotoolkitopenvinoarchiverefstags2024.2.0.tar.gz"
  sha256 "b624481efb7814cf2d98a29163c3b914fa2f23c1417289b13561d0b5e32fc67c"
  license "Apache-2.0"
  head "https:github.comopenvinotoolkitopenvino.git", branch: "master"

  livecheck do
    url :stable
    regex(^(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a7b9f9d82b909f5fb3f7cdb706b4d2815f2ea2825c8c3e1a1211547bcb6a734"
    sha256 cellar: :any,                 arm64_ventura:  "cc54c82fd07e995e939ebd657d407005bb7e4c027233f675d2de418127603aab"
    sha256 cellar: :any,                 arm64_monterey: "a3569f9e6dba9f34d330805fcdea945ba06da240d918c82556c9bf67187ca6ac"
    sha256 cellar: :any,                 sonoma:         "daec83be26bdc5e3e4776da1854602c419cc54a351860d1e9e8b6c2c0ccebb2c"
    sha256 cellar: :any,                 ventura:        "61baddf9e47f14d2d00a3112ddf3250cd171fd5243e6612dc7dffe758fb2bd30"
    sha256 cellar: :any,                 monterey:       "b1a45cf4dbffa48b75b82e9ac462289839b512c88c16319f88a00e34f2780a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c79995d1be93f8819f014585822dfcf221fd31052052134958cbee7cbe8c02"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "numpy"
  depends_on "pugixml"
  depends_on "python-packaging"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https:github.comoneapi-srconeDNNarchive37f48519b87cf8b5e5ef2209340a1948c3e87d72.tar.gz"
      sha256 "58131e094408460f88bf941977b5206232dc2bc8dbf227250d1e2236b43153a5"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https:github.comARM-softwareComputeLibraryarchiverefstagsv24.04.tar.gz"
      sha256 "6d7aebfa9be74d29ecd2dbeb17f69e00c667c36292401f210121bf26a30b38a5"
    end
  end

  on_intel do
    depends_on "xbyak" => :build
  end

  resource "mlas" do
    url "https:github.comopenvinotoolkitmlasarchived1bc25ec4660cddd87804fcf03b2411b5dfb2e94.tar.gz"
    sha256 "0a44fbfd4b13e8609d66ddac4b11a27c90c1074cde5244c91ad197901666004c"
  end

  resource "onednn_cpu" do
    url "https:github.comopenvinotoolkitoneDNNarchive373e65b660c0ba274631cf30c422f10606de1618.tar.gz"
    sha256 "c205b81f9024952c742e765090556a18c9463fff245753a2afa42c344bd6379d"
  end

  resource "onnx" do
    url "https:github.comonnxonnxarchiverefstagsv1.15.0.tar.gz"
    sha256 "c757132e018dd0dd171499ef74fca88b74c5430a20781ec53da19eb7f937ef68"
  end

  def python3
    "python3.12"
  end

  def install
    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdpartyocl
                      thirdpartyxbyak thirdpartygflags
                      thirdpartyittapi thirdpartysnappy
                      thirdpartypugixml thirdpartyprotobuf
                      thirdpartyonnxonnx thirdpartyflatbuffers
                      srcpluginsintel_cputhirdpartymlas
                      srcpluginsintel_cputhirdpartyonednn
                      srcpluginsintel_gputhirdpartyrapidjson
                      srcpluginsintel_gputhirdpartyonednn_gpu
                      srcpluginsintel_cputhirdpartyComputeLibrary]
    dependencies.each { |d| (buildpathd).rmtree }

    resource("onnx").stage buildpath"thirdpartyonnxonnx"
    resource("mlas").stage buildpath"srcpluginsintel_cputhirdpartymlas"
    resource("onednn_cpu").stage buildpath"srcpluginsintel_cputhirdpartyonednn"

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath"srcpluginsintel_cputhirdpartyComputeLibrary"
    elsif OS.linux?
      resource("onednn_gpu").stage buildpath"srcpluginsintel_gputhirdpartyonednn_gpu"
    end

    cmake_args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DENABLE_CPPLINT=OFF
      -DENABLE_CLANG_FORMAT=OFF
      -DENABLE_NCC_STYLE=OFF
      -DENABLE_JS=OFF
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_NPU=OFF
      -DENABLE_PYTHON=OFF
      -DENABLE_SAMPLES=OFF
      -DCPACK_GENERATOR=BREW
      -DENABLE_SYSTEM_PUGIXML=ON
      -DENABLE_SYSTEM_TBB=ON
      -DENABLE_SYSTEM_PROTOBUF=ON
      -DENABLE_SYSTEM_FLATBUFFERS=ON
      -DENABLE_SYSTEM_SNAPPY=ON
    ]

    openvino_binary_dir = "#{buildpath}build"
    system "cmake", "-S", ".", "-B", openvino_binary_dir, *cmake_args
    system "cmake", "--build", openvino_binary_dir
    system "cmake", "--install", openvino_binary_dir

    # build & install python bindings
    ENV["OPENVINO_BINARY_DIR"] = openvino_binary_dir
    ENV["PY_PACKAGES_DIR"] = Language::Python.site_packages(python3)
    ENV["WHEEL_VERSION"] = version
    ENV["SKIP_RPATH"] = "1"
    ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
    ENV["CPACK_GENERATOR"] = "BREW"

    system python3, "-m", "pip", "install", *std_pip_args, ".srcbindingspythonwheel"
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs openvino").chomp.split

    (testpath"openvino_available_devices.c").write <<~EOS
      #include <openvinocopenvino.h>

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
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_PROPERTIES", &ret));
          ov_core_free(core);
          return 0;
      }
    EOS
    system ENV.cc, "#{testpath}openvino_available_devices.c", *pkg_config_flags,
                   "-o", "#{testpath}openvino_devices_test"
    system "#{testpath}openvino_devices_test"

    (testpath"openvino_available_frontends.cpp").write <<~EOS
      #include <openvinofrontendmanager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    EOS
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    EOS

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}openvino_frontends_test").strip

    system python3, "-c", <<~EOS
      import openvino.runtime as ov
      assert '#{version}' in ov.__version__
    EOS
  end
end