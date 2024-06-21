class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.13.0.tar.gz"
  sha256 "f474de87747dd71e69c32de68ec5528436a2edb23898510b41f88f1da8daf074"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "51243bdeaf965a55d609a18c3c9d9c9de020e779a36abccff931d17b84940d16"
    sha256 arm64_ventura:  "2ae69d1a3cf3b50e61346d783b04a73c5fdbea201ad5463eaad939b93b2d6f22"
    sha256 arm64_monterey: "0dc0353c31cd50fa4cd74098fda2a76dc5ae2772ab31ee8721023fc2c8da767d"
    sha256 sonoma:         "66ee8fe83ebdc4d96129f9901e7c33bbca3642f3b85ea6f469d127da2b9ec230"
    sha256 ventura:        "457e00e15cd06915dd70ba5ed9d71863fd74989067e2c993519a5f09593a3bd1"
    sha256 monterey:       "ddc0bcedc67194adc852f354f28c00002cd23ace144886f0bcc81d9093314f49"
    sha256 x86_64_linux:   "be8decae758513a0071a4ce0aafd69b6cf07ae4062907bc0f1eefba3f04a2c7c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

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