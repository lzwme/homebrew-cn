class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "0c602853d2170c7104c767849935851baaf5a2c551ef0add040319ac3afe9bfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56ddd1f6ab51f1f8b41a7806fd0c0df4839b070ab5d73d1084565f24fd2d8316"
    sha256 cellar: :any,                 arm64_sonoma:  "39c6833c49cf5603ca42d2a170f758695d7082a164dd5ee4e434242705ac2e0d"
    sha256 cellar: :any,                 arm64_ventura: "e7e14e1ec9e2f40985c9ec85c3df47a792a445a11e2e1b3d5a42eb7e48b0a066"
    sha256 cellar: :any,                 sonoma:        "1d61d7fa40e55da67af7f8e8ba764d0b9fee1551042ce4db8bba3a74cb3f1638"
    sha256 cellar: :any,                 ventura:       "932c3cf5d1f90ecac5a8abb186240ca8198238d0e626beaa1d57e2b8cecca53b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74dde4573d8d2d4123f1fe4e1b0d05e45a32393ddd6740b79af7c45923095c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcb86cdac59907ef6adf8e1f21841d267a359125925a02e6ec934d5fa632f78"
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