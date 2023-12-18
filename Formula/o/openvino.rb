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
    sha256 cellar: :any,                 arm64_sonoma:   "b0aa311237860c2306a80b141c4e67d4e2e9d2fd2132d76ffe766dfe132a1658"
    sha256 cellar: :any,                 arm64_ventura:  "0cc4f701be585e97f35d548ca300022d58ae48393fc5137b38d94fb7032b6a74"
    sha256 cellar: :any,                 arm64_monterey: "9e3c3415670de1a974c2d8b190f440338db9c0de8cc5ab020e493a1b76f8686b"
    sha256 cellar: :any,                 sonoma:         "fa77326d729799cc6d6009667f465592b206c6a264e07c81db55df7cba28d8ae"
    sha256 cellar: :any,                 ventura:        "2eaec52cf147bea4557d9f46e104981b8961c2f5f03e475c6a6b75aea020b15a"
    sha256 cellar: :any,                 monterey:       "62cbbe1162b3f2f46f651861abb6cc75bf7a81095a836330e0d17b3f2ae7f8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c884c3960706b19b627b762636dc6020067b16e8ce48c82442f4c8f7d6eb2a6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cython" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf@21" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.11" => [:build, :test]
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
    "python3.11"
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
    cd "srcbindingspythonwheel" do
      ENV["OPENVINO_BINARY_DIR"] = openvino_binary_dir
      ENV["PY_PACKAGES_DIR"] = Language::Python.site_packages(python3)
      ENV["WHEEL_VERSION"] = version
      ENV["SKIP_RPATH"] = "1"
      ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
      ENV["CPACK_GENERATOR"] = "BREW"

      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
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