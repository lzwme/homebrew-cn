class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "079bdef3cb6343e5036e3dd86ce2f535a667e5df540e2b51284b47bfd00a359f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9eee8bba47ca232a9593f9ad8ee44fe5421d6eaefdd57916167f19c7555731c"
    sha256 cellar: :any, arm64_sequoia: "62a0febcd7ad0b695ba914e640eb5ff15abcd3b8a80c7cf829402303ba2637d6"
    sha256 cellar: :any, arm64_sonoma:  "26f165ade573dc3df69a963a7c9ffd4ce590764a94481533350943861123408f"
    sha256 cellar: :any, sonoma:        "f83e7717a667bc6c23bf067e89d27954e8c6c6a6c873ff05c2d0ef9fcf784f2b"
    sha256 cellar: :any, arm64_linux:   "3788f0beb822af4bf85f94ef41226e7734e3ddcf1c52313360d49016c78cf5c7"
    sha256 cellar: :any, x86_64_linux:  "a5a9ecc1665fb475494836741a442bb7791cc5cd38f44f6ddb423c440e25cff8"
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