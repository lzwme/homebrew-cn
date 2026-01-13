class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "ce1afcdf5130e74138e93a0f9f0bb77241610d7f00c987f46dffc5fb083f6f0a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "277098df78dadb4b3fa3b902b16a06e979bfb9e5996dea04f2a81c6d961c1138"
    sha256 cellar: :any,                 arm64_sequoia: "f946d06b489e7bd4607637e80a12538b89b3854f62194999c5931e1779b060bb"
    sha256 cellar: :any,                 arm64_sonoma:  "8234b475a484d16cacf55db1f09e78bd31f4d2cfe94985770824ab50cffd7a08"
    sha256 cellar: :any,                 sonoma:        "7137435b771a2f623228832af841f4a7bc54099045df2bcd22f6e94e3acb0251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59310e7af539c72a72fa3218bdab006d1675e3346529371e7d3891058576d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f623566acafe339d666cea00aa6a3f40018aa433438ea3025a97e0cce8ae008"
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