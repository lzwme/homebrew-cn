class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://ghfast.top/https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.1.0.tar.gz"
  sha256 "4d31d1c96e361a01443cb4037293d3fc586568e9bfca13fd7290bc3e20f0ecb8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde8343540f1f7f9383bf48eb394e54b2acee7f43faf895fd3d9c6507a3f6549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1bc43431f47c6e53a16e507b86eca4da4a84118ceeba8081a2ae0501f95d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efce131327ebeb6052343c9b3a828ab911e9327bc4c710bedda1761fde6d65ae"
  end

  depends_on xcode: ["15.0", :build]
  # https://swiftpackageindex.com/grpc/grpc-swift/documentation/grpccore/compatibility#Platforms
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
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-grpc-swift-2"
    bin.install ".build/release/protoc-gen-grpc-swift-2"
  end

  test do
    (testpath/"echo.proto").write <<~PROTO
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
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end