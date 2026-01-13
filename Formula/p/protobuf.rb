class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v33.3/protobuf-33.3.tar.gz"
  sha256 "1c9996fa0466206d5e4b8120b3fceb332369b64248e0649089aad586569d3896"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "99dcbec9fd51287155423d15b2c1d0c1b33968c8ca3994bff881be818bfc7f31"
    sha256 cellar: :any, arm64_sequoia: "f6681df36b2d892cf46834cb521198965fee84afad565c3df4a4a15649daa1f8"
    sha256 cellar: :any, arm64_sonoma:  "77772e5296647df005ed91fe6b9f977b707ed7b58e7e46e23ac20ccdd53818d5"
    sha256 cellar: :any, sonoma:        "7b85ffa6431d5233d026b92ce7d18a37dd7722c4a5b8856f57ce5f40587e64d0"
    sha256               arm64_linux:   "dc1dcc26698801c9ced12b34589a2d0d2e5a7219cdbd86cf595cbf511d6e364b"
    sha256               x86_64_linux:  "a90c5e6adc0a7860fc8bdb9a85589f9220f3317413f947a144e3c553a125253d"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=ON
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_FORCE_FETCH_DEPENDENCIES=OFF
      -Dprotobuf_LOCAL_DEPENDENCIES_ONLY=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
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