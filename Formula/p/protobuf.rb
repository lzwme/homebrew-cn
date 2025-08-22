class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v32.0/protobuf-32.0.tar.gz"
  sha256 "9dfdf08129f025a6c5802613b8ee1395044fecb71d38210ca59ecad283ef68bb"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "90b483aad7b81336695a9510b73c5cd9aec7673a011c8371038ec0e7a459691a"
    sha256 cellar: :any, arm64_sonoma:  "618cd213cdccfad8dadc713182b137e8cb06f409623cc92051745039981c1334"
    sha256 cellar: :any, arm64_ventura: "94157e620da6d0d0fbaffe3a6be2569059fc729254389a6fba90a2c0b28deefa"
    sha256 cellar: :any, sonoma:        "a7e4b68587ed5617a7da88966105f07a27ff03ba0ca65c1f805838cde4dc9980"
    sha256 cellar: :any, ventura:       "8d99bf09b9ce970813085f530bb3933c2a503833a5ef17b34e8b7ebd4f657acb"
    sha256               arm64_linux:   "79cc5788c6a3ee0b2ab55b1e716d8bf97bfac691cdfda1fb19f514448a890282"
    sha256               x86_64_linux:  "c1614bf4cc935166cb462c39c03cd493e1131533197f7480327780e82db1a9ed"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  on_linux do
    # Avoid newer GCC which creates binary with higher GLIBCXX requiring runtime dependency
    depends_on "gcc@12" => :build if DevelopmentTools.gcc_version("/usr/bin/gcc") < 12
  end

  fails_with :gcc do
    version "11"
    cause "absl/log/internal/check_op.h error: ambiguous overload for 'operator<<'"
  end

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