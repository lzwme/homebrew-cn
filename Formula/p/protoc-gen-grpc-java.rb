class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "8c7ec45c35b0956044041799f7a028ccf76eb6c1fc8bde7bb3fcd8d896eb7b70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9421cec4bcf5dbb6194e583bf77f9c9fb999f703159423420d03615c057695f9"
    sha256 cellar: :any,                 arm64_sequoia: "92befd9172ac3054242aed958f42b4c659e54c7fbb5c310bca35dc3396bfb8a5"
    sha256 cellar: :any,                 arm64_sonoma:  "552158c2b8fff89bfbc53097caa7cc53583623d19453511426294935b734f70d"
    sha256 cellar: :any,                 sonoma:        "50e4abac9c12f1fc8af63624fbc419cbd834839742bd28ae91a81523cf327c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ebc543ac727483488a38c706812297bf638c967f1308cc38b224b4015110c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee8fbf3a42a81d72210f2b23ab2e868b8114ebce95acbb6af043307ddc40949"
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