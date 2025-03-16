class ProtobufAT29 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https:protobuf.dev"
  url "https:github.comprotocolbuffersprotobufreleasesdownloadv29.3protobuf-29.3.tar.gz"
  sha256 "008a11cc56f9b96679b4c285fd05f46d317d685be3ab524b2a310be0fbad987e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(29(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "05dfe51811e39fa32877265aeb7b4cf9a094e8c5943efc3e4183757b35ac4618"
    sha256                               arm64_sonoma:  "551d213f9eeb8dca4e54f6903a16bf07d8da1f3282bc95f0ea7768cc3401dc2d"
    sha256                               arm64_ventura: "7706c46083a87311e463ed1fe1276097b46ba9415eef497c6dcc2eab37323065"
    sha256 cellar: :any,                 sonoma:        "350f3ae6f097dc0225487872131b4903de6312ac91e8ac6041736ca5cbfb81a3"
    sha256 cellar: :any,                 ventura:       "74278a0c469b2a17ff8288bab8af9270c4c91c82f224bceddc61b2a55f48163c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b183bb6c8787a6719371f93a0af4c400ba138d88c13b2f68f44476012af62bc"
  end

  keg_only :versioned_formula

  # Support for protoc 29.x (protobuf C++ 5.29.x) will end on 2026-03-31
  # Ref: https:protobuf.devsupportversion-support#cpp
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
    url "https:github.comprotocolbuffersprotobufcommit9dc5aaa1e99f16065e25be4b9aab0a19bfb65ea2.patch?full_index=1"
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

    (share"vimvimfilessyntax").install "editorsproto.vim"
    elisp.install "editorsprotobuf-mode.el"
  end

  test do
    (testpath"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin"protoc", "test.proto", "--cpp_out=."
  end
end