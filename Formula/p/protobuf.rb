class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v33.0/protobuf-33.0.tar.gz"
  sha256 "7a796fd9a7947d51e098ebb065d8f8b45ea0ac313ac89cc083456b3005329a1a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0ef02c40470fe4da9bedd2af6c0b612956747ec52f8bab958595ce75938862ca"
    sha256 cellar: :any, arm64_sequoia: "220d0c9358fda8b85ce23cbb53596547f63895480c16498a6d3b8031710d4b21"
    sha256 cellar: :any, arm64_sonoma:  "93081d8d03451281ff8601acf7e0b225e84fbf4a62eaa41275ee09f35dc150ad"
    sha256 cellar: :any, sonoma:        "8a6f2a3f9550d806334f4ff97fc40f7d93aee9699e4b3437afaa50c5c7ff7791"
    sha256               arm64_linux:   "c1c9bc2529d50ccc22964bc2c983d02aebae785bdd01dcd3c6b8ae0a36ff78f1"
    sha256               x86_64_linux:  "a6adb7c0a034da56bffd83f3f3d6627ac4fbce960e33e4791b15db2d223de79b"
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