class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https:docs.openvino.ai"
  url "https:github.comopenvinotoolkitopenvinoarchiverefstags2024.6.0.tar.gz"
  sha256 "93f417409f3bf12445cb0d72b2af13d849d2b5125d5330d832f1bae55283e5b7"
  license "Apache-2.0"
  head "https:github.comopenvinotoolkitopenvino.git", branch: "master"

  livecheck do
    url :stable
    regex(^(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7edeb52b8c9552ee6cad6442cc319f5c08dd676b24f8d4999fbc619db3d2d100"
    sha256 cellar: :any,                 arm64_sonoma:  "a34f739665997b41f6c770cf51e6c91c150be5f46b56e725cc85d00279d7452d"
    sha256 cellar: :any,                 arm64_ventura: "067f98b78f002caa87d9d24d9160ec1dc1249d7df470aa0ce5da56028fc4cf16"
    sha256 cellar: :any,                 sonoma:        "99f32b556cc59ae1c36ee0dca95ee00a78e7f72e67a394d83c080bc7106d6f22"
    sha256 cellar: :any,                 ventura:       "add49e93888399d80d9cac946b09a0ab681d9d9f2dc2ac9ec262d1826107ef08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3c45accb220464df3103b5e8ddcc8c85e05e5f29e54c9c414a939e7d9044e1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkgconf" => [:build, :test]
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
      url "https:github.comoneapi-srconeDNNarchive0f269193c7466313888d3338209d0d06a22cc6fa.tar.gz"
      sha256 "abad1ff4ac138c593b7a927ef2099b01447af1f7364848392a950ba17b32bcd8"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https:github.comARM-softwareComputeLibraryarchiverefstagsv24.09.tar.gz"
      sha256 "49b8620f21cbbe49e825a131d9eacd548532646289b50e070b83860bd88087fe"
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
    url "https:github.comopenvinotoolkitoneDNNarchivec60a9946aa2386890e5c9f5587974facb7624227.tar.gz"
    sha256 "37cea8af9772053fd6d178817f64d59e3aa7de9fd8f1aa21873075bb0664240f"
  end

  resource "onnx" do
    url "https:github.comonnxonnxarchiverefstagsv1.17.0.tar.gz"
    sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  end

  resource "openvino-telemetry" do
    url "https:files.pythonhosted.orgpackages2bc7ca3bb8cfb17c46cf50d951e0f4dd4bf3f7004e0c207b25164df70e091f6dopenvino-telemetry-2024.1.0.tar.gz"
    sha256 "6df9a8f499e75d893d0bece3c272e798109f0bd40d1eb2488adca6a0da1d9b9f"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def python3
    "python3.12"
  end

  # Fix to evade redefinition errors in ocl_ext.hpp (https:github.comopenvinotoolkitopenvinopull27698)
  # Remove patch when available in release.
  patch do
    url "https:github.comopenvinotoolkitopenvinocommit9736b1811d5916b37473483b237314d0370e2ce8.patch?full_index=1"
    sha256 "ff2dc599930b42f922d0ddc1158e22cdab3590a6e05159efcc307638015c8798"
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
    dependencies.each { |d| rm_r(buildpathd) }

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
      -DENABLE_OV_JAX_FRONTEND=OFF
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

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https:files.pythonhosted.org") }
    venv.pip_install_and_link ".srcbindingspythonwheel"
    (prefixLanguage::Python.site_packages(python3)"homebrew-openvino.pth").write venv.site_packages
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs openvino").chomp.split

    (testpath"openvino_available_devices.c").write <<~C
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
    C
    system ENV.cc, "#{testpath}openvino_available_devices.c", *pkg_config_flags,
                   "-o", "#{testpath}openvino_devices_test"
    system "#{testpath}openvino_devices_test"

    (testpath"openvino_available_frontends.cpp").write <<~CPP
      #include <openvinofrontendmanager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    CPP
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    CMAKE

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}openvino_frontends_test").strip

    system python3, "-c", <<~PYTHON
      import openvino.runtime as ov
      assert '#{version}' in ov.__version__
    PYTHON
  end
end