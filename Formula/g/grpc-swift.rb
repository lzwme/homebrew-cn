class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https:github.comgrpcgrpc-swift"
  url "https:github.comgrpcgrpc-swiftarchiverefstags1.24.1.tar.gz"
  sha256 "812151aeb48e23ded71bdb9b4dc5a46428d97e85743881a79d6b4a9ae4578fd3"
  license "Apache-2.0"
  revision 1
  head "https:github.comgrpcgrpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198302e51eb7bf1810ba698e605aa88f4e292c8f6e0f84053f090bc5f8b27aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69e69fb4d3b8899c3d52c08cf6647f2a4b54afd60913dbb5a4c5a63befcdcf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e1cfb81a7d1d20afbab3cff409963f3a12b9225eab154d610b2c02b552cd3eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba37bbc05dd396c913a5fd609060fadca262d876230a198b974d25b4a7da95b"
    sha256 cellar: :any_skip_relocation, ventura:       "771111724465d309337e1afccdb2b6a9568998a8ea01565004201db5deb35bde"
    sha256                               x86_64_linux:  "7ef3413cc24b0524058efd0081c5f0942253d3e56e2225f80cbd1604444d639a"
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