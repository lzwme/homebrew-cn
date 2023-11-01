class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghproxy.com/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.77.tar.gz"
  sha256 "c60e5d1d1953e40a0687f3734eb7a799e54a74c728da45e0bfbeffa3d13aceac"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "219f7b05f7e5fcc687319def68deabf8e922ac0f0774377271d3e87f6d0a5dcb"
    sha256 cellar: :any,                 arm64_ventura:  "a1fb0be2a32a435fea2ea74a5228a54cd5fa82f8660ab5c05495801e52ecec13"
    sha256 cellar: :any,                 arm64_monterey: "595ce205e324e00016336dee283f16a7f907eca07bd6bd2f999723052e059d7f"
    sha256 cellar: :any,                 sonoma:         "9d1e2daad2c41ed0584d254ce964c8ae24239b276e946ce0a85ad3c7345a6b50"
    sha256 cellar: :any,                 ventura:        "a89c424770fb70274028e46c5fcba9e1e001f37cf0b94e0ac0844932bf5b122b"
    sha256 cellar: :any,                 monterey:       "f0b43183a49871be4c9093f3ebd5b1213caf3d0c617e93f182f3382c16db9dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7505d6576817ae918643e9013eed58fb5478806907f4a49cabe16ecd07a489"
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