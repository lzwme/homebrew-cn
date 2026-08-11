class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://ghfast.top/https://github.com/grpc/grpc-web/archive/refs/tags/2.0.2.tar.gz"
  sha256 "0f0c8c0c1104306d67dad678be7c14efe52a698795a58b2b72ab67a8bb100c15"
  license "Apache-2.0"
  revision 7

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a432c41aac4a61865a9da986c5d10180914ee2e70c5ea1539517fa8e40d7f2b5"
    sha256 cellar: :any, arm64_sequoia: "69d0ffbadb64648ac04cb0fe4b9fcdb1a8c75c7cdc0db66493902a0b6338227b"
    sha256 cellar: :any, arm64_sonoma:  "cfde5519c6d3d35d14681f3426aa62b0466400db0b14f15b33fd8c77efc7b7ac"
    sha256 cellar: :any, sonoma:        "3183b2f6ce488d6527fa897a460ae3894c2fc463a4ae0a14bd905bee768be4e4"
    sha256 cellar: :any, arm64_linux:   "32aaf1ede5e09bcef35bd4d7e5a2aa692a9c34add1093d0e8e6dc8c0d3c18ebb"
    sha256 cellar: :any, x86_64_linux:  "cdc140adb28517e8c80b89c2388e7622a0a74d68eb2a83c1c2f331f822664730"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Workaround to build with Protobuf 30+.
  patch do
    file "Patches/protoc-gen-grpc-web/protobuf-30.diff"
    type :unofficial
    resolves "https://github.com/grpc/grpc-web/issues/1522"
  end

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      message TestResult {
        bool passed = 1;
      }
      service TestService {
        rpc RunTest(Test) returns (TestResult);
      }
    PROTO
    protoc = Formula["protobuf"].bin/"protoc"
    system protoc, "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                   "--js_out=import_style=commonjs:.",
                   "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    (testpath/"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    TYPESCRIPT
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@types/google-protobuf"
    # Include DOM for AbortSignal used by grpc-web 2.x typings; ES level also satisfies @types/google-protobuf.
    system "tsc", "--lib", "es2021,dom", "test.ts"
  end
end