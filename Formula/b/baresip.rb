class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.7.0.tar.gz"
  sha256 "6d213abe7e285356df91e020f1ace154366ca72d2ea767a324abd87f5a920bcb"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "3bc39cac8473f99f7cb3a6dc579dfc5c068d0c456121d5efa68399cbe3e14070"
    sha256 arm64_ventura:  "4bf919159d0de253d4831e469bc3c805df624c67f48d7d5e9dc4b26daa33bbaf"
    sha256 arm64_monterey: "4572684d34b7a5fc7798777816e7e7b55f43ef8b2fa19a34d9c23a9a89493103"
    sha256 sonoma:         "01448a36a8c26277cc4aaeae1950833d0835ad8ed76d651777a8e53ea3103629"
    sha256 ventura:        "c326ee84b51cc2fe510f7405df2bcc5eb8c2af2473fa1c4e9854bb2805a0240e"
    sha256 monterey:       "62c817417257264db0fcbf742b78966357269ff5efda97c91ca7bcc7da4f70ed"
    sha256 x86_64_linux:   "d7f12be2a2e269431786271b670960f1b814ec21d425bf79985b722fbc498873"
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