class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "58d8ad6c798a9a48e48381d0c72f0ccc2b94963e1a7db8c44d8f775042685b0c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a873ec64640e3d335e7303250924eadf2fd13445501b8d5ee5fdd0dd6f0235ec"
    sha256 cellar: :any,                 arm64_sequoia: "b0b0a04732ab4f3e645b489089dbfe29617948f3d9721fbbd37194d89a48c112"
    sha256 cellar: :any,                 arm64_sonoma:  "c23509ffa6d73c74737e9d9c381768cf61154a2f93774ab26984b41c859241f6"
    sha256 cellar: :any,                 sonoma:        "efc35b2084c227d428fee8bfda923b13b81ed452b07af2f5c817df6fb60d0273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f38e2684ae118c3bd430ce0c9aad6f4c3310fdc2072a23a8ebd1dc38426138e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7dc5b676ed4aaab78d3ea1ed1cd092e72b171b95889115261a3617b7618d0f"
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