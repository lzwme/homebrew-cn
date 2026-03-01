class ProtobufAT33 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v33.5/protobuf-33.5.tar.gz"
  sha256 "c6c7c27fadc19d40ab2eaa23ff35debfe01f6494a8345559b9bb285ce4144dd1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "253be052458f64ff0e668bf07337288fc2de74423b82aa3f3213ec93664917d7"
    sha256 cellar: :any, arm64_sequoia: "f6723219c9e3242d7c03fcf3e71b52206d49afe52f9de95c6c92a2199667c917"
    sha256 cellar: :any, arm64_sonoma:  "c495e42cc1e2484c5b4d46af4b945892f279439ad955b7c1cd801b2d1bbb70b0"
    sha256 cellar: :any, sonoma:        "eff25cf0e790a8f7ff30cecef656a3879b86c17e51df9825dca5ebde31ed03d2"
    sha256               arm64_linux:   "8d947603561a14be3f947f16fd726cf143dbc2d410d6fdf308af6c1fdec67d0e"
    sha256               x86_64_linux:  "a8d3efbaf407a35e6155876b71a89bdb4078864f6c3f6fbbc13a1d9993d70293"
  end

  keg_only :versioned_formula

  # Support for protoc 33.x (protobuf C++ 6.33.x) will end on 2027-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2027-03-31", because: :versioned_formula

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