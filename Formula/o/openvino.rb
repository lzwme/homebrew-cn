class Openvino < Formula
  include Language::Python::Virtualenv

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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "07e55f608b78d1de200bf8ba262cdd49ccc30b88dfa0c5895ee0786eba094958"
    sha256 cellar: :any,                 arm64_ventura:  "1fe8c5f82ac6dc9c1d89e62e6807e1865511ca66ab1b46a1775afe95d0fe05fc"
    sha256 cellar: :any,                 arm64_monterey: "25db898560b72b7257f8c1c96c70408b242f13e61968756532b2d88d58ef0483"
    sha256 cellar: :any,                 sonoma:         "8afc3a4da6ecc123564075f00e1ceeea68ea59230e5b33bd2a0483447a83fc12"
    sha256 cellar: :any,                 ventura:        "71ac52208fe7a6f28c3a60697527a7ab3a606bade63a591fabec6975c65f9ac8"
    sha256 cellar: :any,                 monterey:       "0e087e25ec480d08b8780ce17563a9058f5545b0b737197d30e70a355a728835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef42ca92587edf7218c6116bb25df168a3888e686510d480fed91a9c7f71c667"
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

  resource "openvino-telemetry" do
    url "https:files.pythonhosted.orgpackages37dd675a6349e4b5a1d5bfaab940cd52a70c988099b6f4c1689af1884c49815aopenvino-telemetry-2023.2.1.tar.gz"
    sha256 "ca2106b84671c6edfdc562c03b1c6dd3434d649a4c2174aa47f4628aa66e660a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https:files.pythonhosted.org") }
    venv.pip_install_and_link ".srcbindingspythonwheel"
    (prefixLanguage::Python.site_packages(python3)"homebrew-openvino.pth").write venv.site_packages
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