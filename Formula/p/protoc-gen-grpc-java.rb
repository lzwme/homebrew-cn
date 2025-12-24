class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "ce1afcdf5130e74138e93a0f9f0bb77241610d7f00c987f46dffc5fb083f6f0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "114ddfcd7fa4bc32431c1f4493fa17ebff1249f2feff8b09962f9292fb73c6bb"
    sha256 cellar: :any,                 arm64_sequoia: "9fbfe6957b82431c62d83dddc9b484fa530fdc61fcc1567699591f4ba053a41b"
    sha256 cellar: :any,                 arm64_sonoma:  "0312301ddaed393a69176f1e41ae62062d13659224c35b6a8db1b3e671cedd61"
    sha256 cellar: :any,                 sonoma:        "719ecf3cc34f64d1d79505306f97a349eec3fc5dabcfcdf0e968e1563926360e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b854e84c65d2a11f9c4a17dd80a9c11b72be9a65eec1a9df1a887426b93a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118357d05b7bea4841ad1e221e24e16bf401ab3c4271cd449a9d7c8e74bbb223"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    # Workaround for newer Protobuf to link to Abseil libraries
    # Ref: https://github.com/grpc/grpc-java/issues/11475
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", Utils.safe_popen_read("pkgconf", "--cflags", "protobuf").chomp
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp

    inreplace "compiler/build.gradle" do |s|
      # Avoid build errors on ARM macOS from old minimum macOS deployment
      s.gsub! '"-mmacosx-version-min=10.7",', ""
      # Avoid static linkage on Linux
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{Formula["protobuf"].opt_lib}\""
      s.gsub! ', "-static-libgcc"', ""
    end

    args = %w[--no-daemon --project-dir=compiler -PskipAndroid=true]
    # Show extra logs for failures other than slow Intel macOS
    args += %w[--stacktrace --debug] if !OS.mac? || !Hardware::CPU.intel?

    system "gradle", *args, "java_pluginExecutable"
    bin.install "compiler/build/exe/java_plugin/protoc-gen-grpc-java"

    pkgshare.install "examples/src/main/proto/helloworld.proto"
  end

  test do
    system Formula["protobuf"].bin/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end