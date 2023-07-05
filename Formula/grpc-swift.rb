class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://ghproxy.com/https://github.com/grpc/grpc-swift/archive/1.18.0.tar.gz"
  sha256 "40270c9629716f3c3edc6a540ef0d2d0c5da09b5a0b91b68c0ff5f348fc10acc"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e9d0d5625de74d9c57fda9c2cd83f49c2c77ec68f95bd0bf8c5371036f6f1c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6326fe2ecaa04dc26a38164fb6666ecf8763e566d3463984198aa9e981271dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "c296dd085957a900bacb6292c06ab30e34aa8f3e373aa6bb36713a0e439e5c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "287fca7f49183c4e6f134325d9d7daf6a56ce7e9c9fc292de6bff952cc64cfb3"
    sha256                               x86_64_linux:   "fe9a316f610b4d9d79dc23c5455f0891fbe1762d535b45a3461cec66c8214654"
  end

  depends_on xcode: ["13.3", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
  end

  test do
    (testpath/"echo.proto").write <<~EOS
      syntax = "proto3";
      service Echo {
        rpc Get(EchoRequest) returns (EchoResponse) {}
        rpc Expand(EchoRequest) returns (stream EchoResponse) {}
        rpc Collect(stream EchoRequest) returns (EchoResponse) {}
        rpc Update(stream EchoRequest) returns (stream EchoResponse) {}
      }
      message EchoRequest {
        string text = 1;
      }
      message EchoResponse {
        string text = 1;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift_out=."
    assert_predicate testpath/"echo.grpc.swift", :exist?
  end
end