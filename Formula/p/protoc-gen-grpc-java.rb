class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https:grpc.iodocslanguagesjava"
  url "https:github.comgrpcgrpc-javaarchiverefstagsv1.71.0.tar.gz"
  sha256 "2942a56b794479a0bc1c0e69039c9ae615f1cb39d0e3af12af35c0eb3bd73fdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eddb7acbcc4edcc0785283131a80fb2b003917aab3cd72725f879b93241cabfe"
    sha256 cellar: :any,                 arm64_sonoma:  "74ffcffbc652761997d38433bcdfecfde9830bb57bb259a071761b5d3a07957f"
    sha256 cellar: :any,                 arm64_ventura: "6accc306df2fb0278da95c82baa1fdbdd02ebb67e862e41616303df1a689196f"
    sha256 cellar: :any,                 sonoma:        "fb1a984cd2fdaebf1eff1ac2da5c98631e2f4842dbb8ced281a9cb3984d7ac6a"
    sha256 cellar: :any,                 ventura:       "c8a7ee5b8572243073a298694651bce4a6a371ed92339641c03c127cd8252fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5409cf2417b4765cfed0343613f998845d3290c31028b514ee8125e18bce4be"
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