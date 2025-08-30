class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghfast.top/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.85.tar.gz"
  sha256 "3f91d3a4098e09b12839020c3a216004919b60e8c9a1311fb9a0232390ae04e8"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b88e4a2fe3748314c964b82ef6ac3ffb3be43a2ab8a5b05816e95f353c171b4d"
    sha256 cellar: :any,                 arm64_sonoma:  "965cf1e395b6ddbc67e0dd7d5a22c8e18185271e5d64971403392c55d2a416c7"
    sha256 cellar: :any,                 arm64_ventura: "68724970970b9aeaa55a33a85824dbfb4413e3a0b242da9c585727d22b72fe30"
    sha256 cellar: :any,                 sonoma:        "fd4549b6025a009cbbe637c97047148b0a49f3ca9a302333df694373bee5d798"
    sha256 cellar: :any,                 ventura:       "6273c0c0c0ec7b4b13079da45d90beff0f238db6e4a957b7e08415afee365554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c34d679ddd3c0e84a65ceb0a7d02b0fe312504c49753709a5c328bea0c565627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff131dc16fec40b52449a282ba938b5460e9c7998ec56a7115cc7aae2c23de8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
  depends_on "pkgconf" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    which("python3.13")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DUHDM_BUILD_TESTS=OFF",
                    "-DUHDM_USE_HOST_GTEST=ON",
                    "-DUHDM_USE_HOST_CAPNP=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    # Create a minimal .uhdm file and ensure executables work
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <stdlib.h>
      #include "uhdm/constant.h"
      #include "uhdm/uhdm.h"
      #include "uhdm/uhdm_types.h"  // for uhdmconstant
      #include "uhdm/vhpi_user.h"   // vpi_user functions.
      #include "uhdm/vpi_uhdm.h"    // struct uhdm_handle
      int main() {
        UHDM::Serializer serializer;
        UHDM::constant *value = serializer.MakeConstant();
        value->VpiFile("hello.v");
        value->VpiLineNo(42);
        value->VpiSize(12345);
        value->VpiDecompile("decompile");
        uhdm_handle uhdm_handle(UHDM::uhdmconstant, value);
        vpiHandle vpi_handle = (vpiHandle)&uhdm_handle;
        assert(vpi_get_str(vpiFile, vpi_handle) == std::string("hello.v"));
        assert(vpi_get(vpiLineNo, vpi_handle) == 42);
        assert(vpi_get(vpiSize, vpi_handle) == 12345);
        assert(vpi_get_str(vpiDecompile, vpi_handle) == std::string("decompile"));
      }
    CPP

    flags = shell_output("pkg-config --cflags --libs UHDM").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end