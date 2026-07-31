class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "0a110b4565bae8fddc646bb731e733331819d2cf89017764aa68b15495297b81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4438889baea67cda6a217ec7948990414b585d7d161f0a736e7161520268487e"
    sha256 cellar: :any, arm64_sequoia: "c70abb23f996a3e70cdd09bd22a9368052fdc3a1b72a5569681e995b5eff27c7"
    sha256 cellar: :any, arm64_sonoma:  "739989bbf7fadce465cdec42e6c55bce9191060e3ff0b5a614ec0eb9bcac1e66"
    sha256 cellar: :any, sonoma:        "1c32928a7218273bb68829196fce57cf5b0208f7d9c4a3c20b3b31bd619b4b9c"
    sha256 cellar: :any, arm64_linux:   "a9a7720cd3884b8c63acdf729a8b958a98f1b3be382cafbd251b11d93559498c"
    sha256 cellar: :any, x86_64_linux:  "829213cfed5ab25d096323c726a3c1ebdac8a1b706f42a848a8815f57df98a32"
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