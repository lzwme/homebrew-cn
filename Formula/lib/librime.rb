class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https:rime.im"
  url "https:github.comrimelibrime.git",
      tag:      "1.12.0",
      revision: "c7ab6390c143a11d670f3add41218111edb883c9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2378396ddbb8116448a413ccb8b39a3a98b67e23b333da46283021973cd1b237"
    sha256 cellar: :any,                 arm64_sonoma:  "c41ebccc5cec494e2f1c17d2fd6f8aaec95554b729c486b255410608804e37ec"
    sha256 cellar: :any,                 arm64_ventura: "2fe20c928c785db0c7482f8d839cd8f1a66ec313c3a3ea583e4d27660f41d4f4"
    sha256 cellar: :any,                 sonoma:        "99246c970a08bda99591bf4eb7183b524860f90bbc4fb5133d9cdc9448b3eb41"
    sha256 cellar: :any,                 ventura:       "5639cc7d83e4d3eb3e769b62d79fee7e82371878531789ef997a2c4130bc2cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1841313382f3b0664ec5a59ef3a0094ba03059b43c0094b75298e587499a7806"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@76" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "googletest"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  on_linux do
    depends_on "libunwind"
  end

  resource "lua" do
    url "https:github.comhchunhuilibrime-lua.git",
        revision: "b210d0cfbd2a3cc6edd4709dd0a92c479bfca10b"
  end

  resource "octagram" do
    url "https:github.comlotemlibrime-octagram.git",
        revision: "dfcc15115788c828d9dd7b4bff68067d3ce2ffb8"
  end

  resource "predict" do
    url "https:github.comrimelibrime-predict.git",
        revision: "920bd41ebf6f9bf6855d14fbe80212e54e749791"
  end

  resource "proto" do
    url "https:github.comlotemlibrime-proto.git",
        revision: "657a923cd4c333e681dc943e6894e6f6d42d25b4"
  end

  def install
    resources.each do |r|
      r.stage buildpath"plugins"r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_EXTERNAL_PLUGINS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(void)
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, ".test.cpp", "-o", "test"
    system testpath"test"
  end
end