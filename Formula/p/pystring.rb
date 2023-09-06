class Pystring < Formula
  desc "Collection of C++ functions for the interface of Python's string class methods"
  homepage "https://github.com/imageworks/pystring"
  url "https://ghproxy.com/https://github.com/imageworks/pystring/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "49da0fe2a049340d3c45cce530df63a2278af936003642330287b68cefd788fb"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/pystring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7691c2829ccd208b1805929cff0802595a93e1603710279064eae8d05eb4d56f"
    sha256 cellar: :any,                 arm64_monterey: "1890973661e9420d561fbff94d3679ac9cb60e3b224753b9c91313606e26beda"
    sha256 cellar: :any,                 arm64_big_sur:  "d9c0e8a46ac482f4e5e55484cb629263244cd7ab4bc90f9cd25bcac2e28b2755"
    sha256 cellar: :any,                 ventura:        "02c48d989fc55ecf9e197d512c4f256a5338327427492bac35e84d5f89a2de8f"
    sha256 cellar: :any,                 monterey:       "99038ecff46d9ea2ba35f6a3e976d92a2206082c7299447f331914da9477b75a"
    sha256 cellar: :any,                 big_sur:        "e9e60b007a95bba54ef74fdae69c817b3888a8ae05bca19e4f01371a12fc90bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f1dc79610a20ac5cc9376dbb992f7a568554b484f318e24dd621b5c7bae6f0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install "pystring.h"
    pkgshare.install "test.cpp", "unittest.h"
  end

  test do
    system ENV.cxx, pkgshare/"test.cpp", "-I#{include}", "-I#{pkgshare}", "-L#{lib}",
                    "-lpystring", "-o", "test"
    system "./test"
  end
end