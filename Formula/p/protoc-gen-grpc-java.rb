class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "0c602853d2170c7104c767849935851baaf5a2c551ef0add040319ac3afe9bfc"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b854853fd0ef677d57848bd9279e5ff0e9abc5c674c25e912f2a9f17dd8cf5f6"
    sha256 cellar: :any,                 arm64_sonoma:  "454b74c866f9f06feadbacc812f8620696ced96b35b225bde2efb66574eb5b12"
    sha256 cellar: :any,                 arm64_ventura: "01081a0fcf53418987eb258163b136727b1635d9f2c886553f83fda59684e2b1"
    sha256 cellar: :any,                 sonoma:        "37c90105f5d8464955275c13371ec2d66e66cc79ebd2a34798f49a4a6a310fc2"
    sha256 cellar: :any,                 ventura:       "b1e1f8266ba2275601a1524abbd3a16c65d8a9c8710a8cf0b6f3193b16452aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb777b02d19c773ae43f8c9ca90ddaa008a8745f22d222e14911c2c7b28bf64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd2b2e2c8e1bee3ab00e0a5b9eb13d6215e567ac0fc7058b63f45c5491ea6b73"
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