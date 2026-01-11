class Qtgrpc < Formula
  desc "Provides support for communicating with gRPC services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtgrpc-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtgrpc-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtgrpc-everywhere-src-6.10.1.tar.xz"
  sha256 "98138fb8633c4922ef7ef49b8301f7cbfb7beb7897d44d72e639120a29f4577f"
  license all_of: [
    "GPL-3.0-only", # QtGrpc
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # QtProtobuf
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qtgrpcgen; qtprotobufgen
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtgrpc.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "999e0df239f1c59eeadb853b0e8f8f743590a64e947fc4a3f323c8f5de9f277f"
    sha256 cellar: :any,                 arm64_sequoia: "11b2a06ed0a47e7f44d91d937ed9a288ad3aef7f5e1b9e28cb5dd4eabab82bf0"
    sha256 cellar: :any,                 arm64_sonoma:  "0bdca7aeb6b062587515acfe830e299ff5703e600c1cdd6ced1a462c1a1d96f7"
    sha256 cellar: :any,                 sonoma:        "8c343665a9e0c32236e5ec743a0210cbf361cc0832740207735ea75ea1348136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e417790dd141754d3c8472428ad559335a0b3f1c5d7ee75d3c4268e1c1e3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff72f3154f6b72ff69598b8a662d964cf868e2b1df222ee5c26a8ac5cbd5f79d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "abseil"
  depends_on "protobuf"
  depends_on "qtbase"
  depends_on "qtdeclarative"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 COMPONENTS Protobuf Grpc)
      qt_standard_project_setup()
      qt_add_executable(clientguide_client main.cpp)
      qt_add_protobuf(clientguide_client PROTO_FILES clientguide.proto)
      qt_add_grpc(clientguide_client CLIENT PROTO_FILES clientguide.proto)
      target_link_libraries(clientguide_client PRIVATE Qt6::Protobuf Qt6::Grpc)
    CMAKE

    (testpath/"clientguide.proto").write <<~PROTO
      syntax = "proto3";
      package client.guide;
      message Request {
        int64 time = 1;
        sint32 num = 2;
      }
      message Response {
        int64 time = 1;
        sint32 num = 2;
      }
      service ClientGuideService {
        rpc UnaryCall (Request) returns (Response);
        rpc ServerStreaming (Request) returns (stream Response);
        rpc ClientStreaming (stream Request) returns (Response);
        rpc BidirectionalStreaming (stream Request) returns (stream Response);
      }
    PROTO

    (testpath/"main.cpp").write <<~CPP
      #include <memory>
      #include <QGrpcHttp2Channel>
      #include "clientguide.qpb.h"
      #include "clientguide_client.grpc.qpb.h"

      int main(void) {
        auto channel = std::make_shared<QGrpcHttp2Channel>(QUrl("http://localhost:#{free_port}"));
        client::guide::ClientGuideService::Client client;
        client.attachChannel(std::move(channel));
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "."
    system "cmake", "--build", "."
    system "./clientguide_client"
  end
end