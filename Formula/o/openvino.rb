class Openvino < Formula
  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https:docs.openvino.ai"
  url "https:github.comopenvinotoolkitopenvinoarchiverefstags2023.2.0.tar.gz"
  sha256 "419b3137a1a549fc5054edbba5b71da76cbde730e8a271769126e021477ad47b"
  license "Apache-2.0"
  head "https:github.comopenvinotoolkitopenvino.git", branch: "master"

  livecheck do
    url :stable
    regex(^(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dbaa768c272a0934254ebbf863e6c63ade5141d3717727f4b88bc3a915a57b99"
    sha256 cellar: :any,                 arm64_ventura:  "d48c2a20108f28f33a9d765aa2ce3cb8ee5312228976ea0233892f3d6c8ff4e5"
    sha256 cellar: :any,                 arm64_monterey: "a324bc3e99dd85d1830a8fc8fb3c47af65bf1674de11bb796ee9490cd739f097"
    sha256 cellar: :any,                 sonoma:         "309ebf4e8e62eaa304694e02f36b002588638265d7cdf80549f26f3378f632f5"
    sha256 cellar: :any,                 ventura:        "f133c8b1fa3a50d8aa478e7151eb5f76b47b83e6b627a328c461e620f1b47273"
    sha256 cellar: :any,                 monterey:       "20d832372096a92bc8aec5ee6264d94f20f3d81815b77357b8b5f7e67cabe12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae02ea2f43ca2744e0396777ec7c43a0656dd4e0e5301feae422d7c98b97797"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cython" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "numpy"
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https:github.comoneapi-srconeDNNarchive284ad4574939fa784e4ddaa1f4aa577b8eb7a017.tar.gz"
      sha256 "16f36078339cd08b949efea1d863344cb0b742d9f5898937d07a591b0c4da517"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https:github.comARM-softwareComputeLibraryarchiverefstagsv23.08.tar.gz"
      sha256 "62f514a555409d4401e5250b290cdf8cf1676e4eb775e5bd61ea6a740a8ce24f"
    end
  end

  on_intel do
    depends_on "xbyak" => :build
  end

  resource "ade" do
    url "https:github.comopencvadearchiverefstagsv0.1.2d.tar.gz"
    sha256 "edefba61a33d6cd4b78a9976cb3309c95212610a81ba6dade09882d1794198ff"
  end

  resource "mlas" do
    url "https:github.comopenvinotoolkitmlasarchivef6425b1394334822390fcd9da12788c9cd0d11da.tar.gz"
    sha256 "707a6634d62ea5563042a67161472b4be3ffe73c9783719519abdd583b0295f4"
  end

  resource "onednn_cpu" do
    url "https:github.comopenvinotoolkitoneDNNarchive2ead5d4fe5993a797d9a7a4b8b5557b96f6ec90e.tar.gz"
    sha256 "3c51d577f9e7e4cbd94ad08d267502953ec64513241dda6595b2608fafc8314c"
  end

  resource "onnx" do
    url "https:github.comonnxonnxarchiverefstagsv1.14.1.tar.gz"
    sha256 "e296f8867951fa6e71417a18f2e550a730550f8829bd35e947b4df5e3e777aa1"
  end

  def python3
    "python3.12"
  end

  # Fix linux build with our OpenCL
  # https:github.comopenvinotoolkitopenvinopull22051
  patch do
    url "https:github.comopenvinotoolkitopenvinocommit0d455544f599ca5b2bb8993f209a01e7b61a336e.patch?full_index=1"
    sha256 "67a1ba9296d3f23eeb5a3cf95dfe24171657d21e6cc6eef372a7e308f57a3092"
  end

  def install
    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdpartyade thirdpartyocl
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

    resource("ade").stage buildpath"thirdpartyade"
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
      -DENABLE_TEMPLATE=OFF
      -DENABLE_INTEL_GNA=OFF
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
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_METRICS", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_METRICS", &ret));
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