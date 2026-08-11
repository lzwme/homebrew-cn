class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "0a110b4565bae8fddc646bb731e733331819d2cf89017764aa68b15495297b81"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e8f55c05274bacf5fe614d9b7762e86f7f1166e33c1351b8568426feafbea2f"
    sha256 cellar: :any, arm64_sequoia: "0ed993a6c0965da19480a4208b3c69c003a36663be0516a3f4099d08c0247b4d"
    sha256 cellar: :any, arm64_sonoma:  "ac90de8a663437190d7debd83f1bc1826124661e9ecde4a1728a1e77a3829f09"
    sha256 cellar: :any, sonoma:        "d422335388f89642bd02d4c82fcda2c9109e58ab652de867eaf1394a54bb97f8"
    sha256 cellar: :any, arm64_linux:   "d1744a8e4e5032f0e44ab8c79bc1a7ba26ce1306183175a4117de1ba72915913"
    sha256 cellar: :any, x86_64_linux:  "195cad3ba876da63c7402ab95b01769340e465d4e7eb9982ff3a97d6bf54674a"
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