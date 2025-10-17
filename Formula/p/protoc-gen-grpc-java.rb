class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "8c7ec45c35b0956044041799f7a028ccf76eb6c1fc8bde7bb3fcd8d896eb7b70"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "347fa553cf8ac4ee16b0fe983c1b98fae32c58df48beba1fd3ca52df20d60772"
    sha256 cellar: :any,                 arm64_sequoia: "fc1a7dd8de9c5e2c66f34c5f234678f36cfd3bd48d2dc94126cfdbeb9a6c3582"
    sha256 cellar: :any,                 arm64_sonoma:  "03ea239f91f56203f8dbb64b9c3292147cc3d625af0ff6046d3ec3d2503750b3"
    sha256 cellar: :any,                 sonoma:        "674fe206527e0d336ff94846b4d42664e9f208bf045aaac130abffdb293a898b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03612155b04355f33e7076ca671b64a64b21303ab177a5df1db9d52b521e7c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9a063380cc50f735e80478560c4f4480937998d91ae09d5d0d2a72514cfe34"
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