class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v32.0/protobuf-32.0.tar.gz"
  sha256 "9dfdf08129f025a6c5802613b8ee1395044fecb71d38210ca59ecad283ef68bb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ab97edc2342f988444997ca6ca308ae6f6c3c89e6e967aa70bf042c3e6023f32"
    sha256 cellar: :any, arm64_sonoma:  "5cc1bb324c546c7bcafd2a80bc7510fd725b92f6a3ece9331fa141c0eed895a2"
    sha256 cellar: :any, arm64_ventura: "3cdd2320b3529673f8bba771296d159fc852c97aa4c519bdcfbeeb84716676ea"
    sha256 cellar: :any, sonoma:        "1f47ab9a1ed9f4701d5687cf8670cdf10cdbd94689d5ee3b49179f42f23a1dfd"
    sha256 cellar: :any, ventura:       "743a9b45dbd80262c4110508555a6273fc1373952a162a9dbc979f75222b834d"
    sha256               arm64_linux:   "e53d1aea835c576dc4b51d0634ccd067b15d4f25f6e55ca42ee136dd283561d9"
    sha256               x86_64_linux:  "1da247995c1f5fa95d7d6c7327b9b3dcb6b8930f362a54d1209c97f2f88584d5"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  # Apply open PR to fix CRC32 usage on arm64 linux
  # https://github.com/protocolbuffers/protobuf/pull/23164
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/1cd12a573b8d629ae69f6123e24db5c71e92e18c.patch?full_index=1"
    sha256 "b1676b4c8a4a20dec9a7c0fe2c6e10ccf35673d6f3f6dce1ef303f37d0a0aa5b"
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