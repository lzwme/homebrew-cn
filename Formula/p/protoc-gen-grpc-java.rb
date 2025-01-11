class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.69.0.tar.gz"
  sha256 "5c3178f118190d73f52460d671c7b6fc42249b7b5890d228ce422f2ca20b1a68"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e16a95c0540c03122426db81510da216f5313b29c816fa30b3590ab561b0952"
    sha256 cellar: :any,                 arm64_sonoma:  "393766f25543b33ecd854f7a87c94e429e593cbb35688626ac58781b23a4fe38"
    sha256 cellar: :any,                 arm64_ventura: "f19e6822010c37db3c7406e137ef962f029d7d2858db7a21d053bcc393abfc5d"
    sha256 cellar: :any,                 sonoma:        "0cd12587c837678762ac98e7dc58244d22836e2050ecd0369cb0391e020433ec"
    sha256 cellar: :any,                 ventura:       "36b8539b6f04500acb896a909013995f6c9a5e699ffb4ee3eb525703801c21fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552563ec76cfea819effe8513faa62a340f3f8765750a9398a4685a07d11abfd"
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