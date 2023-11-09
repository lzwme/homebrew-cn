class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghproxy.com/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.78.tar.gz"
  sha256 "7335a70f2ac1ea9193f845262cd223255df5cd65b591ca4f74c75f9c8612cad9"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7dd602cc5386d64a1b2dd5a93f213f2880c0d9f2eba5ef5e05c32ae156db752"
    sha256 cellar: :any,                 arm64_ventura:  "5438796cdcada96ead48b6dadd5d7b344c1eb09c49ba6fe142c9ed726f3a4570"
    sha256 cellar: :any,                 arm64_monterey: "6b0741a25370526476932e5db854470f1c46769785f75558b6fe61a041bfd877"
    sha256 cellar: :any,                 sonoma:         "9d2a47fbcb58e17da9e8e415b76fd820b3c8fb017b86c83ba9f5447d173bc55d"
    sha256 cellar: :any,                 ventura:        "6e7e138839fac7b2f2c6e787ab9c988330f1156402528540956a6471f64b5ee0"
    sha256 cellar: :any,                 monterey:       "47cff10e35f0ca287435d928db31462362e819ed96afe8de677f3a1a1242c89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0a5dbbf84b71dc1ebb3c0d3083c275385dfbcc281ca19200048b5d7e1a52ed"
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