class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://ghproxy.com/https://github.com/baresip/baresip/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "be2da5049938acb180a130ccf05ccde12ae1b8409a54d3577349c070d3710d2a"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "fc613884114cf5188deece2f14cc732325f33320769c35147ce98f0efeb1b085"
    sha256 arm64_monterey: "81e8f0a6b515530c311b14c7ef572e40c64b564e0b143879deec1ddf6dd4b0be"
    sha256 arm64_big_sur:  "b072d168a1ca85a857d65d1012c192ae63ab290920531eac2e68cfbff1156d5b"
    sha256 ventura:        "2581e28f1220e2bb58e5afdfdc1962dbf0dd492596d9cfe143bc9b463b0ce11f"
    sha256 monterey:       "3ec8a36322b1c1238750937e9f61b8e9f0657045947305881387a3502f4fa6ba"
    sha256 big_sur:        "4dbba7cd75df823f9c077f1804e4c3da5455fd524af12b17c1615285742b7081"
    sha256 x86_64_linux:   "9b719d1f674d1f077021aec54c05a531ab82d9ade2584b731701c4cb5bcfd296"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end