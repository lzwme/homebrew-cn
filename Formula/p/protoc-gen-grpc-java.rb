class ProtocGenGrpcJava < Formula
  desc "Protoc plugin for gRPC Java"
  homepage "https://grpc.io/docs/languages/java/"
  url "https://ghfast.top/https://github.com/grpc/grpc-java/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "f69046e810124bbc3af0baa5a6b9c9f26fbf0c3d1c8303b32d4efad71262d83d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8661f3f85b508d15e6ee3d05b10fc16422df1a3832a474f15acaf702bf4baae0"
    sha256 cellar: :any, arm64_tahoe:       "725eadc25622f7b6ffc779d88046d92462879d21b797ccd5316920b5921c80c0"
    sha256 cellar: :any, arm64_sequoia:     "994b6e8119522529801b940bd2278b1c525a562f1ad34d50c270cc35cd99a9e1"
    sha256 cellar: :any, arm64_linux:       "d2c0f076c5470af2652ff226056ee7aa429e93ff8464577545d97ee66d0b8a0b"
    sha256 cellar: :any, x86_64_linux:      "a65a9a5691fcec9561a1d93718753c4de16faddc1233e80c8c3194075fd05000"
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
    system formula_opt_bin("protobuf")/"protoc", "--grpc-java_out=.", "--proto_path=#{pkgshare}", "helloworld.proto"
    output_file = testpath/"io/grpc/examples/helloworld/GreeterGrpc.java"
    assert_path_exists output_file
    assert_match "public io.grpc.examples.helloworld.HelloReply sayHello(", output_file.read
  end
end