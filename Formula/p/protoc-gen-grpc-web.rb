class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://ghfast.top/https://github.com/grpc/grpc-web/archive/refs/tags/2.1.0.tar.gz"
  sha256 "7dfe1a7fe858b2f43a4504f9378739b02371a30f5ec2823df529713a73ad681c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2293a338b58fc39e2c45002137945f9887a3900df97900b20abb14f581fbbbbb"
    sha256 cellar: :any, arm64_sequoia: "6e4bd25ba6d97dda3235312b5b0b0f9344107f6f55e1b927c483d3670321a4f4"
    sha256 cellar: :any, arm64_sonoma:  "d1020c5c09636ee61ea1016c9621c58cbe5a572931d6e1e175cc2e569592aff5"
    sha256 cellar: :any, sonoma:        "d19881ac94c0c0fea6e367b41a9de8ec1834f8ac8a5a2fc3228545e607a7f2eb"
    sha256 cellar: :any, arm64_linux:   "d5c347a96aa29e769bf4556751490bbef9c6856f5f2ba483a4c601558c624d67"
    sha256 cellar: :any, x86_64_linux:  "edb08d1ad9f1dca283d816e9b9fa237979a6dc48d4ea3db5adc91db3c88aac4b"
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