class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "8c7ec45c35b0956044041799f7a028ccf76eb6c1fc8bde7bb3fcd8d896eb7b70"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "591ce4a1f59b933dacea996ac01f564dfd96997b97aa5f2c8774b31d80131e10"
    sha256 cellar: :any,                 arm64_sequoia: "59179fadc460280d724139b62d6d044db29ff5c45cdaf8b28489090e62cdbf47"
    sha256 cellar: :any,                 arm64_sonoma:  "fc2fc90dd2da358aceb0b30bee7d03d1ea3663235fc92770cedcbd960ffd2f76"
    sha256 cellar: :any,                 sonoma:        "5307ffa683813ccefb60347eba2b4c1b5224734264a741c0f46f176ba2739d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4daf8bb2577320392776da2a19527296ec994dc3c1120b8533b734bdea2a911f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751e1990c62a854531ae5a835b7ff3ce97ff844d79b07728ad136c9bd4a35744"
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