class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.36.0",
      revision: "86970144a0b86068c81ff48ee29b3f97cae0b879"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9ca0a577c9cb2f9ebe4330f749a3d8686c0ab5b14b0adfe1da8ed1cb389004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992f7ff85cbf7b439b993de028d8d1e7df2541db4b8ae65865f1e568608a230c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3389d87220d62c9ebba6cdc7c11ac4e735abaf3374789c38619104555bc82e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "900495eff7ecf96b887ed00e43865cf5f9c5f818e124ceabeb0c891e948c53a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a9bc77c85f15ca26604f39275f4f8caf6456c96a4641a85a0c323d25473d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219f74ababc364cdf20bac51edd34f52611abe34092773bc94e7f7e55e369ab3"
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