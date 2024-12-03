class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.68.2.tar.gz"
  sha256 "dc1ad2272c1442075c59116ec468a7227d0612350c44401237facd35aab15732"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "341faf5bfb58c9b66d8125f13f4ba2df0c04f5c2399182a58d4dc22580aed63b"
    sha256 cellar: :any,                 arm64_sonoma:  "3085a73cf17253d55994083f536b81d76c9a4e3a3e95078c6fb26688567f41f7"
    sha256 cellar: :any,                 arm64_ventura: "c7901410547f1d7fed00e88c3dcb2c8cee89e2a572f19cacf8ff85ba6e3abfe7"
    sha256 cellar: :any,                 sonoma:        "3024ae1dca662042d54cfc017a7def5ee34393dbf675f78bf5a3dbf7193d4801"
    sha256 cellar: :any,                 ventura:       "51658d35fbb323d2cfacea2cc657c4325b3bab0fec35802e65ecdda8dbf21016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b17544fb60d27a9b5bca4cbdebf6ef0df3209a7ad50a8356d16f1b82898d6d"
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