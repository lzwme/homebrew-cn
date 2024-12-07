class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.68.2.tar.gz"
  sha256 "dc1ad2272c1442075c59116ec468a7227d0612350c44401237facd35aab15732"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9bd029369494555fbac2e0ceb782c8e9ee8e3c60aef5d764f8e871e47e0abbc"
    sha256 cellar: :any,                 arm64_sonoma:  "8fae0ab13517f9db6c63e3edac8d26be6283528ebe49df8623488a79b665e044"
    sha256 cellar: :any,                 arm64_ventura: "65f3a83b4bb88f709b140af84ee91dac2935ff26a9965c2441d07fcd80db471d"
    sha256 cellar: :any,                 sonoma:        "fe055e58371d129edd9a003955cbf2608346a2f3defbc64bfa7bf85432e9641f"
    sha256 cellar: :any,                 ventura:       "3a1ebe5574fce77911f9b1f9a007e013bafdbb7e81be2a982a79c60002112be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ced8afd60cdd73d9227cd6ad8d5bfb2eccb28cf1825f857078fe647e37df17"
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