class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "82d76f952bf30b8d6abc94572ac171ae0a8391b1d49bb82d162e39b986c52284"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0de02bca3dec59832a83f8dc7b4e0e523320c48fd0570589565f3afd1d2e82e1"
    sha256 cellar: :any,                 arm64_sonoma:  "2efdb623faf5ebc549a76b6ba10b6c86b6db00d3d8e47534ffff8e84605fa1f0"
    sha256 cellar: :any,                 arm64_ventura: "621dfe98c20011488e9aee7e3206d5034199fafa6eab2c91481d990c75df68b0"
    sha256 cellar: :any,                 sonoma:        "c37f4f21d0034cdb2d73a6c39f6df56f63733d24aa12ac6a3a7641f7f89c81e1"
    sha256 cellar: :any,                 ventura:       "252be3da05b8893cc57cdbfd036b5de2426ac423803e6340cebe20fbff4ef30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe12915bfe3529518c7b2b83b1be03a079d7085c8740008c112be27290ad2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699426e5242961447922152ae2174b6e6f92804b291028ebf36844306bd7a294"
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