class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.35.1",
      revision: "5596511fce902e649c403cd4d6d5da1254f142b7"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d904435c14a74f3bae452aae88b4568d83c9692c5bbac560b4a510e677baada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ad36a547033d132820740dd3407b5f4448759d3c44ac8d0d016ad5a34e22e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a30170126a1330c46e1c3058a699e99ac8e594e5d58ed8b0a49b34623c9db429"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cedaae1c605e90efdd73ce02497a2a7595bebb5e4adf00d11f3c829312bc806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f59f8627a3eded13fe811529888de947e7a42ec6e9d44de0f9aff7a3579b5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1360af0c771988b4660edbbc9ffbef30859b8c6d59e294ebf482d9977b6a33f"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-swift"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end