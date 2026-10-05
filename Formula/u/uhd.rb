class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://ghfast.top/https://github.com/EttusResearch/uhd/archive/refs/tags/v4.11.0.0.tar.gz"
  sha256 "1e53faec13ea2be9dd8f765956157d1434f41fa0a124fac8f7b2340f8445b026"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "8e97b65c35c514e84b3962a8e2047897f347221da665f3d32578a9f5eb10762c"
    sha256 arm64_tahoe:       "24d0cbfdbf2e439c93d052f0e28b2ad79794828a244b3476e4a6a0188cd97c80"
    sha256 arm64_sequoia:     "6a590e3c359eb967d2606a0ed474bcf13595ef8ea473c83a8c849c1978a0bd6f"
    sha256 arm64_linux:       "4a246347940199a3a4d0d4d21bb03463259bbf4f292312f9c49ade4b68fa6ad8"
    sha256 x86_64_linux:      "33402626089b2322c4db0b81ba050d95099185f90f84dc952925c315192c26cf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "re2"

  on_linux do
    depends_on "ncurses"
  end

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/2a/12/b5fa2353e2754cd67fb9f83793fa48ff42c213a5da7e719869d2301f6ab8/mako-1.4.1.tar.gz"
    sha256 "d7904710b662996425a21627710c4777c45053146942cf8a7aebf757c92b8c27"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  # Fix macOS library namespace, upstream PR ref, https://github.com/EttusResearch/uhd/pull/947
  patch do
    url "https://github.com/EttusResearch/uhd/commit/2dc0ecf9288a2556da762fd6693600f1572ecd2d.patch?full_index=1"
    sha256 "4e6bf9735767e245c87b57221c54e623cb76de3f9fa957787435b1ba20a2065c"
    type :unofficial
    resolves "https://github.com/EttusResearch/uhd/pull/947"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON
      -Dprotobuf_MODULE_COMPATIBLE=ON
      -DGRPC_CPP_PLUGIN=#{formula_opt_bin("grpc")}/grpc_cpp_plugin
      -DPYTHON_EXECUTABLE=#{venv.root}/bin/python
      -DENABLE_DOXYGEN=OFF
      -DENABLE_MANUAL=OFF
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <uhd/types/device_addr.hpp>

      int main() {
        uhd::device_addr_t address("type=b200,serial=1234");
        std::cout << address["type"] << ":" << address["serial"];
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-luhd", "-o", "test"
    assert_equal "b200:1234", shell_output("./test")
  end
end