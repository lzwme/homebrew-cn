class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.2.tar.gz"
  sha256 "5936550a32ebbb0761be7f061497d7627e66e8e4e25f30eca81013cec48a9f93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "36228c3169207894359a9cb4efd30614511c122017b9f107ef59c2794c73e3bc"
    sha256 cellar: :any, arm64_tahoe:       "995c1cbe25ccb50811f17b528840da59f9abdf2f6731784e3cf775f2c70e5864"
    sha256 cellar: :any, arm64_sequoia:     "4853f8d5f3bc130fbbc63df1bfe1f40e2027d4be161fd26a74688fdcf255cfd3"
    sha256 cellar: :any, arm64_linux:       "3f9dd9ed27910d3b8b73c0bc8074793f95b119ed6cc6254cb857a6a1f6d23ee3"
    sha256 cellar: :any, x86_64_linux:      "a4366a4116b008a93fea90accb569a133f34a875726287b1936ac3f574c3529f"
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
    system formula_opt_bin("protobuf")/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end