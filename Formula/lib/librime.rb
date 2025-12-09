class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.15.0",
      revision: "75bc43ae9acdd2042d150a8c446e9ac8b6d77c84"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01b95ed9e57b54a5152df3154dcf1e6b3b5704829d29ea0608370e7387af5019"
    sha256 cellar: :any,                 arm64_sequoia: "5513652e0d0665e9b0db5176c3ce8c505897bf21575908dd2d656338e16f597c"
    sha256 cellar: :any,                 arm64_sonoma:  "1a7addad03c24515f8bb410736699c92e25741ddefa72afaab42eeb43a798e9a"
    sha256 cellar: :any,                 sonoma:        "d125fe0c51fc2b8c4335de66a5987da66e6add132dde309cfe6df46bcb456515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67878900d8bb70087d5df5e455daaec0615858a72153c55cffd27bbff13d4703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0faad9a3ae6c72ba5f08547eaffbefcb1ffd5ad70fcccad2c63362b8d6eb794"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua.git",
        revision: "68f9c364a2d25a04c7d4794981d7c796b05ab627"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram.git",
        revision: "dfcc15115788c828d9dd7b4bff68067d3ce2ffb8"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict.git",
        revision: "920bd41ebf6f9bf6855d14fbe80212e54e749791"
  end

  resource "proto" do
    url "https://github.com/lotem/librime-proto.git",
        revision: "657a923cd4c333e681dc943e6894e6f6d42d25b4"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_EXTERNAL_PLUGINS=ON
      -DBUILD_TEST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(void)
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, "./test.cpp", "-o", "test"
    system testpath/"test"
  end
end