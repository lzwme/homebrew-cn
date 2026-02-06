class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.34.1",
      revision: "c5ab62237f21cad094812719a1bbe29443407c5f"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c9afa37729fe35c1dedfe0c8183b328d78868998b916390eb2594ab3bb35c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d4954084ed1aa7a4b9fbc746c0532d9f4d74522387da462b408c2dad0c8d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a519c953f6a2b8592e2eb26c36ed3bfd6d95963ad60f4b75622022e7d3d85e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "296578b4104cf66a4ddebbc5c9b4f02e3c7c959b42d3293bd0689cbb4f037d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12948e6df98e055fca4d85a6bd4939c6b6ac5bc3489c08e45557969ccd463285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f5b08f9ce7c5771dedab9c4731079fbcad68fea33eeebab5ab7f30c9831c57"
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