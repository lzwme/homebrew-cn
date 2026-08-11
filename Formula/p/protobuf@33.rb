class ProtobufAT33 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v33.6/protobuf-33.6.tar.gz"
  sha256 "16498d7dc7967e9b100632138babd4b86b61592beeccdd556f67539d9c231355"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "82c54b2aaaaa299167196586184f44f4047983f872fcab589250c012d9fbc26f"
    sha256               arm64_sequoia: "71cad6c33faf7e861c3d12ac8cbb5aeae1b2f8acd565e47d7786b7be0dc9bc6b"
    sha256               arm64_sonoma:  "21a13ed6e43e99f2427da7cbf67a2fe60cddee46e1da00c5fb4c469d032516f0"
    sha256 cellar: :any, sonoma:        "d4b186a44fb48461b8a2ff9049b221fa0e71b7bf01659f69eed2f11efdc904cd"
    sha256               arm64_linux:   "cab77ca77cfa43f8c0a97f1810ba131f146d885d91169cbb3f80d35a0ff6e590"
    sha256               x86_64_linux:  "aacf2d085f9f81adbaa184b1e18ad6732e7ecbc2a665f66e5c1eff2309b56798"
  end

  keg_only :versioned_formula

  # Support for protoc 33.x (protobuf C++ 6.33.x) will end on 2027-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2027-03-31", because: :versioned_formula
  disable! date: "2028-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"

  on_linux do
    depends_on "zlib-ng-compat"
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