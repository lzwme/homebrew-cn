class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https:github.comgrpcgrpc-swift"
  url "https:github.comgrpcgrpc-swiftarchiverefstags1.22.0.tar.gz"
  sha256 "5cfad7b5a3892548d9cb243230e3094b93a3cd3830cc918a06694ad28976e26c"
  license "Apache-2.0"
  head "https:github.comgrpcgrpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3de3c53329127d542a3ee58f99717046830a16aeb7d286623faa1cb3cdce50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5fa11d430409403de394d8037cc48ff03357856f507647e4cf67f00aff19ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "749f016af485fe76ac677c407636acaaaf6a6a8be2bd880ac4aa749938c674b6"
    sha256 cellar: :any_skip_relocation, ventura:       "8c01132e982055a21b9e79ff3c21fe3d5ed1a9b695dd35e6245ec3bfbbe2bf9a"
    sha256                               x86_64_linux:  "1b5f993597e83f6b0a992da9d989f3562e1ad54440762a233ad82d3c40ceff7e"
  end

  depends_on xcode: ["14.3", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".buildreleaseprotoc-gen-grpc-swift"
  end

  test do
    (testpath"echo.proto").write <<~EOS
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
    system Formula["protobuf"].opt_bin"protoc", "echo.proto", "--grpc-swift_out=."
    assert_predicate testpath"echo.grpc.swift", :exist?
  end
end