class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.70.0.tar.gz"
  sha256 "14e31cc6605afc3f1d8bd04767ec741f49eada314a167dd45886206c31341e33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b70698f884694f3e2cc568d468be6e0a2317eec766e52fa4978200445b9a0203"
    sha256 cellar: :any,                 arm64_sonoma:  "a5529380842c516553a400c8cf4e0a5ed0715380adb14d36a2091ad2827ad6d1"
    sha256 cellar: :any,                 arm64_ventura: "c46e467b28cf7733d21150b83b4dfa904ead213fda4e5bbf420c7a5b7d67467f"
    sha256 cellar: :any,                 sonoma:        "0e24d39e214a7eb3e8aef997ccb118e813b110a71a7c0f19ee62f5fecdd4054e"
    sha256 cellar: :any,                 ventura:       "c240aaeff937e3a188981d1dc6cdf704cf355f8c8b1551d0ef71ec1c9f0dc359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0cbab28f53aced7391db6f85af8d55a825bbfaac7ba2c4d196c9c3a233b580"
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