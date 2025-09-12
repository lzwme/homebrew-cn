class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://ghfast.top/https://github.com/apple/swift-protobuf/archive/refs/tags/1.31.0.tar.gz"
  sha256 "34b866853e9e91bda868b912a88da8b976d12924f9a1c1046a505e5c0730bdfc"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d117e037a891e1c9f76fa73cb18f0d12de501c3cab9ab63396ae1bd487c91a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db496d0b907e9b9093f79240df48b7acd02bd0050491623643ca2878e32701e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "535bfe50132dd72cbc6610debd3dfddd8f0ffe22a021a8c151acc03ad4ff1346"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85c5881dcbdecbb8d3c40f299faf4d7b668465e15d7ab14737ef79ff6540d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7dde1ce8e2ac683416b29374a05ffd527ea4681c8d8833486adf3bcc13c3965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7713022073d893733fd6d0d0c13b42e03342cc301c30d54cf10fd02332a455"
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
    system "swift", "build", *args, "-c", "release"
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