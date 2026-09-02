class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "4ac03e3244da9565f13f62a24e87f57ee13baa7657033db35ea086e16fc32869"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fbd2f9a4eafc061d06d7e9809b0feb65db7f12172ece860ee711c55aaa723d4e"
    sha256 cellar: :any, arm64_sequoia: "32202da692a1448a2b169cfb48cef37a2f23b3a8825483c0db1faf294276957a"
    sha256 cellar: :any, arm64_sonoma:  "37d3ffe2b43fb9dd13ae340a63288dda0a7c9ce9e33a0ffa0088b62f548ab0fd"
    sha256 cellar: :any, arm64_linux:   "1a1b05d5e905b2f63020f4f307e3e4d164d1b085d2f39791af7eade50cb9e406"
    sha256 cellar: :any, x86_64_linux:  "f97238f90c88dbfa98db0ca477e4e28db72922a294d8463d6598094e29dcefdd"
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
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{formula_opt_lib("protobuf")}\""
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