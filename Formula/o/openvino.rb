class Openvino < Formula
  include Language::Python::Virtualenv

  desc "Open Visual Inference And Optimization toolkit for AI inference"
  homepage "https://docs.openvino.ai"
  url "https://ghfast.top/https://github.com/openvinotoolkit/openvino/archive/refs/tags/2025.2.0.tar.gz"
  sha256 "15cd5c9beb320a8feadd18bcae40970608de154d5057277281dc53dd7023e383"
  license "Apache-2.0"
  head "https://github.com/openvinotoolkit/openvino.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "11b74025a0332e818ce71c9a88cefd86ab97fd473f766274f5630982ec6ae37b"
    sha256 cellar: :any, arm64_sonoma:  "7a8f95ba5f9f994800547a17b7ec2e02799c16ad510f5bed148f3e13343765cb"
    sha256 cellar: :any, arm64_ventura: "5cbde31722a51f88bdd4d3fe5b323bc898bc2e0450d1809e26d5805d3308fd44"
    sha256 cellar: :any, sonoma:        "0730eb6c247836061f16d578e78be64b3b55d5a017da2d9075fc3bdfbdfb071b"
    sha256 cellar: :any, ventura:       "f793cd9c8d4763de4fbc6e8a7fa9d475c78ef70d08dbeeefc42d59e0f547326f"
    sha256               x86_64_linux:  "93bab6f4d95a8b1af5026c9e6c9391aee2fed7c3022a9e5de7a145dcfcfe9be9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "flatbuffers" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pybind11" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "abseil"
  depends_on "nlohmann-json"
  depends_on "numpy"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "pugixml"
  depends_on "snappy"
  depends_on "tbb"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "opencl-clhpp-headers" => :build
    depends_on "opencl-headers" => :build
    depends_on "rapidjson" => :build
    depends_on "opencl-icd-loader"

    resource "onednn_gpu" do
      url "https://ghfast.top/https://github.com/uxlfoundation/oneDNN/archive/c7d59a12849295c8bdf6401b8ea3968f4346ee0c.tar.gz"
      sha256 "05bc693ee788768f18397bd235ad40f55261e4336a683469a50072bfddbf9f98"
    end
  end

  on_arm do
    depends_on "scons" => :build

    resource "arm_compute" do
      url "https://ghfast.top/https://github.com/ARM-software/ComputeLibrary/archive/refs/tags/v25.03.tar.gz"
      sha256 "30f83cea6d338a0e33495c33c547b7b720027baff4c3eea66014709fdd52aaac"
    end
    resource "arm_kleidiai" do
      url "https://ghfast.top/https://github.com/ARM-software/kleidiai/archive/eaf63a6ae9a903fb4fa8a4d004a974995011f444.tar.gz"
      sha256 "756fa3040ff23f78a4c3f4c1984a3814d78d302b0b5dc3f0b255322368aefc58"
    end
  end

  on_intel do
    depends_on "xbyak" => :build
  end

  resource "mlas" do
    url "https://ghfast.top/https://github.com/openvinotoolkit/mlas/archive/d1bc25ec4660cddd87804fcf03b2411b5dfb2e94.tar.gz"
    sha256 "0a44fbfd4b13e8609d66ddac4b11a27c90c1074cde5244c91ad197901666004c"
  end

  resource "onednn_cpu" do
    url "https://ghfast.top/https://github.com/openvinotoolkit/oneDNN/archive/793dd02883483385fb7ee3b1af1e4273ce833444.tar.gz"
    sha256 "f6ae708f5b78361cab2c544a976d66bd7ccd74b4b6df7710d4d86a383f6916f9"
  end

  resource "openvino-telemetry" do
    url "https://files.pythonhosted.org/packages/71/8a/89d82f1a9d913fb266c2e6dc2f6030935db24b7152963a8db6c4f039787f/openvino_telemetry-2025.2.0.tar.gz"
    sha256 "8bf8127218e51e99547bf38b8fb85a8b31c9bf96e6f3a82eb0b3b6a34155977c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def python3
    "python3.13"
  end

  # Fix to add adhoc sign back for Homebrew.
  # Remove patch when available in release.
  patch do
    url "https://github.com/openvinotoolkit/openvino/commit/f89181e38b64eee8296623c1caf9870164beff89.patch?full_index=1"
    sha256 "6483957f1ed1ad41bb50e699b177c69991380c2b44fae3567180dfa4d82e3374"
  end

  def install
    # cmake 4 build patch for third parties
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # FIXME: workaround for
    #   CMake Error at cmake/developer_package/version.cmake:102 (message):
    # OpenVINO_VERSION_MAJOR parsed from CI_BUILD_NUMBER () and from
    # openvino/core/version.hpp (2025) are different
    ENV["CI_BUILD_NUMBER"] = "#{version}-#{revision}-"

    # Remove git cloned 3rd party to make sure formula dependencies are used
    dependencies = %w[thirdparty/ocl
                      thirdparty/xbyak thirdparty/gflags
                      thirdparty/ittapi thirdparty/snappy
                      thirdparty/pugixml thirdparty/protobuf
                      thirdparty/onnx/onnx thirdparty/flatbuffers
                      src/plugins/intel_cpu/thirdparty/mlas
                      src/plugins/intel_cpu/thirdparty/onednn
                      src/plugins/intel_gpu/thirdparty/rapidjson
                      src/plugins/intel_gpu/thirdparty/onednn_gpu
                      src/plugins/intel_cpu/thirdparty/ComputeLibrary]
    dependencies.each { |d| rm_r(buildpath/d) }

    resource("mlas").stage buildpath/"src/plugins/intel_cpu/thirdparty/mlas"
    resource("onednn_cpu").stage buildpath/"src/plugins/intel_cpu/thirdparty/onednn"

    if Hardware::CPU.arm?
      resource("arm_compute").stage buildpath/"src/plugins/intel_cpu/thirdparty/ComputeLibrary"
      resource("arm_kleidiai").stage buildpath/"src/plugins/intel_cpu/thirdparty/kleidiai"
    elsif OS.linux?
      resource("onednn_gpu").stage buildpath/"src/plugins/intel_gpu/thirdparty/onednn_gpu"
    end

    cmake_args = %w[
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
      -DProtobuf_USE_STATIC_LIBS=OFF
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version}.0"
    end

    openvino_binary_dir = "#{buildpath}/build"
    system "cmake", "-S", ".", "-B", openvino_binary_dir, *cmake_args, *std_cmake_args
    system "cmake", "--build", openvino_binary_dir
    system "cmake", "--install", openvino_binary_dir

    # build & install python bindings
    ENV["OPENVINO_BINARY_DIR"] = openvino_binary_dir
    ENV["PY_PACKAGES_DIR"] = Language::Python.site_packages(python3)
    ENV["WHEEL_VERSION"] = version
    ENV["SKIP_RPATH"] = "1"
    ENV["PYTHON_EXTENSIONS_ONLY"] = "1"
    ENV["CPACK_GENERATOR"] = "BREW"

    # Allow our newer `numpy`
    inreplace "pyproject.toml", "numpy>=1.16.6,<2.3.0", "numpy>=1.16.6"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    venv.pip_install_and_link "."
    (prefix/Language::Python.site_packages(python3)/"homebrew-openvino.pth").write venv.site_packages
  end

  test do
    pkg_config_flags = shell_output("pkgconf --cflags --libs openvino tbb pugixml").chomp.split

    (testpath/"openvino_available_devices.c").write <<~C
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
          OV_CALL(ov_core_get_property(core, "AUTO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "MULTI", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "HETERO", "SUPPORTED_PROPERTIES", &ret));
          OV_CALL(ov_core_get_property(core, "BATCH", "SUPPORTED_PROPERTIES", &ret));
          ov_core_free(core);
          return 0;
      }
    C
    system ENV.cc, "#{testpath}/openvino_available_devices.c", *pkg_config_flags,
                   "-o", "#{testpath}/openvino_devices_test"
    system "#{testpath}/openvino_devices_test"

    (testpath/"openvino_available_frontends.cpp").write <<~CPP
      #include <openvino/frontend/manager.hpp>
      #include <iostream>

      int main() {
        std::cout << ov::frontend::FrontEndManager().get_available_front_ends().size();
        return 0;
      }
    CPP
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.13)
      project(openvino_frontends_test)
      set(CMAKE_CXX_STANDARD 11)
      add_executable(${PROJECT_NAME} openvino_available_frontends.cpp)
      find_package(OpenVINO REQUIRED COMPONENTS Runtime ONNX TensorFlow TensorFlowLite Paddle PyTorch)
      target_link_libraries(${PROJECT_NAME} PRIVATE openvino::runtime)
    CMAKE

    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_equal "6", shell_output("#{testpath}/openvino_frontends_test").strip

    system python3, "-c", <<~PYTHON
      import openvino.runtime as ov
      assert '#{version}' in ov.__version__
    PYTHON
  end
end