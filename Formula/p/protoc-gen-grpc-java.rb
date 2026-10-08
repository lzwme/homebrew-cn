class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.84.1.tar.gz"
  sha256 "d86d12da8668f49c3d0101ea8cbb83dbf380f89a429b7ec526224827f76f2c63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81ea4bbfe17828183a079b1800a679bb516c071d526452d469815341fd33ee77"
    sha256 cellar: :any, arm64_tahoe:       "66d6239ccf6feb438a61d9fdef376fe001396fd3c9ba29b683a2922ba0d433e8"
    sha256 cellar: :any, arm64_sequoia:     "405831ff50e7e5a615eac8f40f9fd8094bd90396ef0082572d52a9bf65e94a30"
    sha256 cellar: :any, arm64_linux:       "14bdee377ef1c706bc637c445ec94e447cec04725a290c23bfc73d41fe622ce6"
    sha256 cellar: :any, x86_64_linux:      "1f084a36fc278945a303599ca0a9780cd186cf3dac5464ef1fc049287b42ea47"
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