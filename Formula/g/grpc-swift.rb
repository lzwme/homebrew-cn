class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https:github.comgrpcgrpc-swift"
  url "https:github.comgrpcgrpc-swiftarchiverefstags1.24.2.tar.gz"
  sha256 "06f504ec5ce4b375e48e25983d06bb7f55dea126a65669d326def832c8da3581"
  license "Apache-2.0"
  head "https:github.comgrpcgrpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a3718fec21c195890abd756f9367c397ea99d35af5d299602cb57fb08dbad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67eb22f2334a994e04bfc6ab89d2f3427812d478240434163108bed1a6494b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac62dc16446915e1d0df21846c2688ec7080fb0c2faf183df50d0359b0c57d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "26896664dc139e80c7b8d08fc0ea44fcd506fe3643a278c3e80b7acb5893ad39"
    sha256 cellar: :any_skip_relocation, ventura:       "5fcedf2f3a4fa371ed947446d396b4dafaf0f8ccda8885f16a64a2b15c6731bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44b36b070eed8ad0209fd694490d6b0b31cf53cbe9516061ff266d517e8af04"
  end

  depends_on xcode: ["15.0", :build]
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
    assert_predicate testpath"echo.grpc.swift", :exist?
  end
end