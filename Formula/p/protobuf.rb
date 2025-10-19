class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v33.0/protobuf-33.0.tar.gz"
  sha256 "cbc536064706b628dcfe507bef386ef3e2214d563657612296f1781aa155ee07"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "68e78815df265bd26b52c98e9dc54a2be61ccb9096b0faffcd946ef929a9b29d"
    sha256 cellar: :any, arm64_sequoia: "c2209942fec8de30bdca4568a4dc0d2c8966012b8d2cfa2fdcf198ea9e67a348"
    sha256 cellar: :any, arm64_sonoma:  "5e88a2f82b5a8cb8f724923ec4b64f7e172d0b443083932a268e952d60fab5d5"
    sha256 cellar: :any, sonoma:        "f2178c6185be41da78c713f08126e26b8e7b029b667ff7980213d706446ba487"
    sha256               arm64_linux:   "8150ba1722485b78d81ad35b11ae05dd279758599be46e80024755c7b35f1adb"
    sha256               x86_64_linux:  "ae607e3c7968673570431d1f9efdfbbe08ed8e9ccc1e4f8ae4612d4818e753e8"
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