class ProtobufAT29 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v29.4/protobuf-29.4.tar.gz"
  sha256 "6bd9dcc91b17ef25c26adf86db71c67ec02431dc92e9589eaf82e22889230496"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7df9f175047b553b9cbd70602fca73e535577883dcc30d095b1af853d3a4326d"
    sha256 cellar: :any,                 arm64_sonoma:  "05e011455870beee2797a8636cf4f675148cdfa4b4626c36e885a1cb5f28d232"
    sha256 cellar: :any,                 arm64_ventura: "7bb8c67ee713014d6f4ce1c80a4646bfefedaa98d67e81c18d39c5d39c88153b"
    sha256 cellar: :any,                 sonoma:        "62cf175d0bbbf7b3f30f8a63b82a780f859464738262aabbc3b916f6d059c7e9"
    sha256 cellar: :any,                 ventura:       "34718efecd02045d06d6b0d881f316276cb27cf432b700c53a7e556469c23e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b42fd2d37afdd16c7594fd5eaec3284571a0df5143daab658b316541606327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11db073384e8413f15dcac5e756c67da1a8d6734841efa474c1824f5bbae48a8"
  end

  keg_only :versioned_formula

  # Support for protoc 29.x (protobuf C++ 5.29.x) will end on 2026-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2026-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  on_macos do
    # We currently only run tests on macOS.
    # Running them on Linux requires rebuilding googletest with `-fPIC`.
    depends_on "googletest" => :build
  end

  # Backport to expose java-related symbols
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/9dc5aaa1e99f16065e25be4b9aab0a19bfb65ea2.patch?full_index=1"
    sha256 "edc1befbc3d7f7eded6b7516b3b21e1aa339aee70e17c96ab337f22e60e154d7"
  end

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose" if OS.mac?
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end