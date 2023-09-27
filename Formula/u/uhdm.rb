class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghproxy.com/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.75.tar.gz"
  sha256 "7dcb999a6b04b1abe40d40db25e6269470313c09804ce8285cc450c2f0bcd446"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a82d03b201bded54960c022e616ed3c44dfd937a8d9f2182fc7e9fc785b56286"
    sha256 cellar: :any,                 arm64_ventura:  "6782fbef862b157140c0b732cc4d262ca6a7fce39a2776134cf325f9f534cc90"
    sha256 cellar: :any,                 arm64_monterey: "62eb446dbc78114b04c821253aaac41ce889d1ba864f0bedae15498b51274e9e"
    sha256 cellar: :any,                 sonoma:         "e594b4f586c771f43fdd5b00c7902da52fa5932e94185b8c6472032a0d76cc5c"
    sha256 cellar: :any,                 ventura:        "9776099fa953829d9393f90ef62cd4bc1a7ea67e28b64999e6363ace2ab93f20"
    sha256 cellar: :any,                 monterey:       "3b77d76a019c0d12849d153a47a125ba6b98f528670838468c365e2d9d4a0758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504d025c6cbd09635dd51d9405721b6fedc13a50ee79656c1a2829df2715692f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "six" => :build
  depends_on "pkg-config" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.11")
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