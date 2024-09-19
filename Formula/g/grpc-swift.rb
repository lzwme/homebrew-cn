class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https:github.comgrpcgrpc-swift"
  url "https:github.comgrpcgrpc-swiftarchiverefstags1.23.1.tar.gz"
  sha256 "566f260fac492287e3d3003cb274a0a1bf135acaf428d24d86d2aecb9a9a603e"
  license "Apache-2.0"
  head "https:github.comgrpcgrpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67a4b8d6c1be218e00e0499e172829de9d9c441a03b963c9444c981031dafa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c873ed905e081325e183cf9b28dbfc68cc22cf2c1dad6d95f91ed529f9fc378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da34265ee4478c4bbfc86b8d710a1322a54024931a05818cae03a71cb0d8a09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bcc41ec6df284edb76c460cf4286bc25fb2d6cbfeec7e6b638356fa14dd7821"
    sha256 cellar: :any_skip_relocation, ventura:       "44d57497c38ac579691ca0714a4e55ef854eac7e39a4aecd6e758ef482160168"
    sha256                               x86_64_linux:  "820e70fba4988ad95d1d660f593fd816430a5475c57c9a8caffe9af808c3ca26"
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