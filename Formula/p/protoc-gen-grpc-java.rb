class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "0c602853d2170c7104c767849935851baaf5a2c551ef0add040319ac3afe9bfc"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a67f189920a2fa700082a4235e7c2376c4736f5d090f5b59eee21e9143cc6fb"
    sha256 cellar: :any,                 arm64_sonoma:  "bc062489079d15f2733ba424c78da97900f1afba1860856ea24c551c402afa6b"
    sha256 cellar: :any,                 arm64_ventura: "678e61ab88db8e7625940377ef3ab229a8a665db9f1feef7b5690d172e6c2e9b"
    sha256 cellar: :any,                 sonoma:        "a30139278d327ccc27896ac6f91593412cf337e8812561cf84d1a5a99d809638"
    sha256 cellar: :any,                 ventura:       "be3e9043d4e25fcb3663f9d30ef40315abbf69a434e929f19b45c6855033c4b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858c996ef21b6cc2e41628e6758ae899eba2a8430e3143833856e9d10663691f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d929a87b16535d0fa033f00579f19c753e3e6f25a8cfa2ccecfc0f5158aef1f5"
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

    system "gradle", "--no-daemon",
                     "--stacktrace",
                     "--debug",
                     "--project-dir=compiler",
                     "-PskipAndroid=true",
                     "java_pluginExecutable"
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