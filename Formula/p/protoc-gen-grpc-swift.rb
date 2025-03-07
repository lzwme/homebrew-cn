class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https:github.comgrpcgrpc-swift-protobuf"
  url "https:github.comgrpcgrpc-swift-protobufarchiverefstags1.1.0.tar.gz"
  sha256 "fe19d6931605e957031369578ab03faa6b3b3ad8fdee0214a08275ef209f36f9"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comgrpcgrpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c9c068affc59d455635cf5d2749d3f36eb35ea8bb05bdea9a708df1b90497d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f196d46a031f46add8ca18b687de951994fc96f007099125b2acb5b64a84da2"
  end

  depends_on xcode: ["15.0", :build]
  # https:swiftpackageindex.comgrpcgrpc-swiftdocumentationgrpccorecompatibility#Platforms
  depends_on macos: :sequoia
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".buildreleaseprotoc-gen-grpc-swift"
  end

  test do
    (testpath"echo.proto").write <<~PROTO
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
    PROTO
    system Formula["protobuf"].opt_bin"protoc", "echo.proto", "--grpc-swift_out=."
    assert_path_exists testpath"echo.grpc.swift"
  end
end