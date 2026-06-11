class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "079bdef3cb6343e5036e3dd86ce2f535a667e5df540e2b51284b47bfd00a359f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "962180d23632a81e1df7584942efd6227d96b21c723bfc5249413fbe292f3fed"
    sha256 cellar: :any, arm64_sequoia: "d6045279afbba64d873980020959f44aaf721b8d5f319f9ce39b1dcd1c6ea796"
    sha256 cellar: :any, arm64_sonoma:  "22dd298bcdd124e5cc54ead1921045d8abde9755cc7086cf745873e419aef6bc"
    sha256 cellar: :any, sonoma:        "aeb1791e5eef33bbd6b3c74d0661720997487406d5fb15872e56b5fb023050fb"
    sha256 cellar: :any, arm64_linux:   "709a19e0fe92d0df73b09ef595b9c44906bf7c8cb28a8fc0b5aae843849835da"
    sha256 cellar: :any, x86_64_linux:  "f2ee117d20724d56b4e4aa8ca4d905e6fa5e47d462c7099ee03e1b21c2755f2c"
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