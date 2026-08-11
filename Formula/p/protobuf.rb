class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v35.1/protobuf-35.1.tar.gz"
  sha256 "f0b6838e7522a8da96126d487068c959bc624926368f3024ac8fd03abd0a1ac4"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "075c0a9b7245c0153e1fa5a5d36902ba7ff105ccdfa0189bdb0087da63a8295a"
    sha256               arm64_sequoia: "0e9bf6238af6d86c2badd0c455f38356f3444e5619bb1c0e7ca394c42fe05ac7"
    sha256               arm64_sonoma:  "eb6ef725c8213e264321587e8defd073c5e417e5b1af4ea8f662bfe4c3955cee"
    sha256 cellar: :any, sonoma:        "3ffa938d3c26df8283b9a82c58befff9e6d9efc9170360aefdc50ca1f579a93d"
    sha256               arm64_linux:   "4ca55124284822867cf30627d73a6e25732433be2c5d6d81919adfb152d51c12"
    sha256               x86_64_linux:  "a5d0ea542a70586595a7a18db20ceedc9717d7c155af4368b1615ed1b15d8a2f"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  on_macos do
    # TODO: Try restoring tests on Linux in a future release. Currently they
    # fail to build as Clang causes an ABI difference in Abseil that impacts
    # a testcase. Also GCC 13 failed to compile UPB tests in Protobuf 34.0
    depends_on "googletest" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling ABSL_ATTRIBUTE_WARN_UNUSED"
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