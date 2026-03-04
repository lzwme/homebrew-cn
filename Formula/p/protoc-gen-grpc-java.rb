class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "ca53210ee823a15d9b1ebe86a36b564d6834fd0c049e207469803180b7f8a20e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc81166bfbbc64d147609055d187836c7d5d98b66070850895f6e7d8b134ea8d"
    sha256 cellar: :any,                 arm64_sequoia: "9cee2620a2d6b1734ded57f18c4eabfedc4d6e5a2a5e2d3420916f7a8f6d435e"
    sha256 cellar: :any,                 arm64_sonoma:  "a2a233dbdd5668345efc8d62a6ad35a16e8ff014cb2fb4d6affd60975946c87a"
    sha256 cellar: :any,                 sonoma:        "e93bf22c25a6b22f88c701d2d852bc1fcb0f8cc11b62b9a04376400e5556c2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4966cfe5e4db1cfd53cd3f48a2c147709bc0c5c123bb62092248462be8d5cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff97c8b8d59d873bd5fb5025542edba9443b939d68b7809d1a50184cd4478be3"
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