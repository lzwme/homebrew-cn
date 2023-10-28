class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://ghproxy.com/https://github.com/apple/swift-protobuf/archive/refs/tags/1.25.0.tar.gz"
  sha256 "f4b4bc7d5637dbdd9b65ddbc1d0351975c5dee92c6b38ecb74bd325c50540d4c"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10cc899dfb1d549043c767b6ba031514da04dddf9bfda8f42cd72f5f33f4abe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "878c6ec3e88e7a314868ddf01e1346d3aa66d354c327889917010e70f9ea83ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b3a97097eb0853783105d9a3aca36d4db890087238c8bab54f1995137b50a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "76bd5d93e6ea46bf2ccbe81672f24b1536cca8de4c0818b3a972163a2c60649b"
    sha256 cellar: :any_skip_relocation, ventura:        "d8717225519dffec172e77ca851f2831a67fcef4af32e2abd3d53bb366f0e044"
    sha256 cellar: :any_skip_relocation, monterey:       "b96cd28dbf8f1b9d6b3e0eff2d666618af36b9eae915188a00558f398e3ea454"
    sha256                               x86_64_linux:   "c41cf5728e32d394bcfa424f54b6712cb6ffa676f95ba918b5e00dd94f3ea96b"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end