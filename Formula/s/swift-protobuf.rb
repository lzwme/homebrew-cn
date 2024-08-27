class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https:github.comappleswift-protobuf"
  url "https:github.comappleswift-protobufarchiverefstags1.28.0.tar.gz"
  sha256 "6bf8c176748f7424c701917bde0b0433cc09d6401489162c49dd1904847c37df"
  license "Apache-2.0"
  head "https:github.comappleswift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b8ab33b28a6997fb5a36c325cc9f789f4b622a3f0c7ab5bbf060bb40b204c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2925d0b45603630d5921a7c40cf648720cfe9bb24702cabf13879eed5831048d"
    sha256 cellar: :any_skip_relocation, sonoma:        "96af8d58e8725abff28e3bed07e61581ec70eb4367cdb4f08825eb3a109cff36"
    sha256 cellar: :any_skip_relocation, ventura:       "5e568076ce4492fe35fda0fa4527d93113639e9fce80752803baa53b874598ec"
    sha256                               x86_64_linux:  "95be4e445ce10c012ba6df751d20c46b0c867adec28740638121f1e415d6143e"
  end

  depends_on xcode: ["14.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildreleaseprotoc-gen-swift"
    doc.install "DocumentationPLUGIN.md"
  end

  test do
    (testpath"test.proto").write <<~EOS
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
    system Formula["protobuf"].opt_bin"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath"test.pb.swift", :exist?
  end
end