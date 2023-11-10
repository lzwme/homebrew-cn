class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghproxy.com/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.79.tar.gz"
  sha256 "4b50a26632306143f4b60b73aca77e18926c983ee3c818baf077ced61b34c617"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8bdbfbb9dd70995eddf1325adbe56117e258e8b7bf8f6df210bf7f334cd85b64"
    sha256 cellar: :any,                 arm64_ventura:  "15eb681a81f6e63ab755ac008602ce964f6de265210749dabb5093bcbde6eaea"
    sha256 cellar: :any,                 arm64_monterey: "b7e4563be4a5e950f9a43fc0cd5446081268d2ecd4293fd20704016ead6226da"
    sha256 cellar: :any,                 sonoma:         "2d2635b4958fc49e322b39157b5cbb4bcba43f0dbf9e682b4122b8f0d52f6aa5"
    sha256 cellar: :any,                 ventura:        "b98c196f9fc0dac416607572283df402e692a70d402f7771606b1a2e56bb3286"
    sha256 cellar: :any,                 monterey:       "0a9aca1ad3b1a67c778de079b0895f92b30abfc49007061b7d8d19a5f33efee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1263bd639fb4bfc947f2fc001065e425de2c41cd54de47a633f7b6047b61e30f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "six" => :build
  depends_on "pkg-config" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    resources.each do |r|
      venv.pip_install r
    end
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
      "-DBUILD_SHARED_LIBS=ON",
      "-DUHDM_BUILD_TESTS=OFF",
      "-DUHDM_USE_HOST_GTEST=ON",
      "-DUHDM_USE_HOST_CAPNP=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    # Create a minimal .uhdm file and ensure executables work
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs UHDM").chomp.split
    system ENV.cxx, testpath/"test.cpp", "-o", "test",
      "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end