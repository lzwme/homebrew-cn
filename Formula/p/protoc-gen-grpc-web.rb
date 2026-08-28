class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://grpc.io"
  url "https://ghfast.top/https://github.com/grpc/grpc-web/archive/refs/tags/2.1.1.tar.gz"
  sha256 "7766763275c6bf99115c9b535aaa3c507566847d47ea72a1f70da7fe427a98d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "94e254571c386b448fd26a55b842fcdca371b6a6b27925fc3a02bb4f596e0bc5"
    sha256 cellar: :any, arm64_sequoia: "f0e1e41e2603bb7cf70ea1eb122b7eebd771641b6b9749c530999c66fd9f142c"
    sha256 cellar: :any, arm64_sonoma:  "96461e3a1c4ec4cdcc1519391f3b51ea4c5649f7288091dcd53641e5dd3b28ae"
    sha256 cellar: :any, sonoma:        "fb0cd2f44822ad436d9b5035346618f9f2d08cef38428361f21ee2067800a74e"
    sha256 cellar: :any, arm64_linux:   "ddf19d0c023f55a4e7866a39919af426592c1d6850876af3362dbb450e2d7c2f"
    sha256 cellar: :any, x86_64_linux:  "192ed9864398c5a40f5936adec821e9a8bd83f827926c46de25087499ca23ee3"
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