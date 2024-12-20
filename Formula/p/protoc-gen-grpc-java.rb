class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.69.0.tar.gz"
  sha256 "5c3178f118190d73f52460d671c7b6fc42249b7b5890d228ce422f2ca20b1a68"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7233bee8aa11c24b84b5b12c0d653059a2a8beb4cb09a4b4d1fbfba3fbdfb4e"
    sha256 cellar: :any,                 arm64_sonoma:  "a5d03b39175152b3de075a3f91d30bbee7fcf75e8ab9349fd7d22bfb946702ec"
    sha256 cellar: :any,                 arm64_ventura: "cbfbef34610db941d0acd3a43ca4e752c3f37d07e51f809c10233a3d944cd87a"
    sha256 cellar: :any,                 sonoma:        "25ef38649ae0edd15660ceefb79d572d3a395773d2610f7aad8e6176a324de1e"
    sha256 cellar: :any,                 ventura:       "b653b716fc88a1b77704fba7f7d125e0161c246906df07fb2e9f34b4ca766433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8af80522f0d63166dc2055170fb94dd98b2e67a278c541650757ccf34888fe3"
  end

  depends_on "openjdk@21" => :build # due to Gradle 8.5
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    # Workaround for newer Protobuf to link to Abseil libraries
    # Ref: https:github.comgrpcgrpc-javaissues11475
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", Utils.safe_popen_read("pkgconf", "--cflags", "protobuf").chomp
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp

    inreplace "compilerbuild.gradle" do |s|
      # Avoid build errors on ARM macOS from old minimum macOS deployment
      s.gsub! '"-mmacosx-version-min=10.7",', ""
      # Avoid static linkage on Linux
      s.gsub! '"-Wl,-Bstatic"', "\"-L#{Formula["protobuf"].opt_lib}\""
      s.gsub! ', "-static-libgcc"', ""
    end

    # Fails with brew `gradle` due to animalsniffer 1.7.1
    # Ref: https:github.comxvikgradle-animalsniffer-pluginissues100
    system ".gradlew", "--no-daemon", "--project-dir=compiler", "-PskipAndroid=true", "java_pluginExecutable"
    bin.install "compilerbuildexejava_pluginprotoc-gen-grpc-java"

    pkgshare.install "examplessrcmainprotohelloworld.proto"
  end

  test do
    system Formula["protobuf"].bin"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath"iogrpcexampleshelloworldGreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end