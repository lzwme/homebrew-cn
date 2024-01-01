class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.8.0.tar.gz"
  sha256 "372923a0d96bd7a9fdd6e06c58e6ac4d674c864e4963c252a8bf04189cdb139c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "f45ed7571296208ebd9e6d1a917d786c3f7e9e6217e51a348f9d11341ebb4814"
    sha256 arm64_ventura:  "85d07a3cf99d421a8ae81a115791162573863dc0c778b4a1adc39fbe59ef5fb8"
    sha256 arm64_monterey: "89a8cb2fe49619f9f03636f8074cb741616c2d3c9bbefa64c2cd9d15970bb498"
    sha256 sonoma:         "a10d65d48efea93af50dc3657bb4fa569b5d56a73c3d653d84ea58bf62aca7d0"
    sha256 ventura:        "d6038e60cc8760598d43cf4536763d52803b5f1701c5f5637ee470eb76d70c8a"
    sha256 monterey:       "44e449ae6c5dd93d972f59015aeee84c91e53c436733e385d58370b4eff326cb"
    sha256 x86_64_linux:   "794404ebd9535821f54181772896acfa8639d15c99ee55efdd810415b17b40da"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end