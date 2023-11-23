class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://ghproxy.com/https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.80.tar.gz"
  sha256 "e28cbae0e8bccc2c428356b109c254fe51169839bc55dd1091de9f24406a00f8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0058b4ec3185a43bc5866dd283d02f044d1a544b3878d043452b301a89672861"
    sha256 cellar: :any,                 arm64_ventura:  "fef58ac455328f5afb82c0047c6c239f98922848eb5aae0c3163d2dd31cfd21b"
    sha256 cellar: :any,                 arm64_monterey: "dd32952e15db240dea406164e9b3e837b64407115a1e5a4b0b7d0a33ff470d03"
    sha256 cellar: :any,                 sonoma:         "6def05494db99b36a7dea4c3e0d0e698fd2d416fb9e908a4b88fb3eb5852e708"
    sha256 cellar: :any,                 ventura:        "7908bdf1e4b54278494027a12d25cf460f5fa9c733145271655a38319e6b0301"
    sha256 cellar: :any,                 monterey:       "4d195f6f189bb871f2f8a97f769a9bb74b4188d905661d9c31fa47db89d6f255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c2cf9257c224ceb88ae3e9067e01144429fc2403d59fd47bd9182bf5b015e8"
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