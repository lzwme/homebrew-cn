class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https:github.comappleswift-protobuf"
  url "https:github.comappleswift-protobufarchiverefstags1.28.1.tar.gz"
  sha256 "9204c512ee90378f22db3255ecc35de927d672a4925d5222497c57b3f30de726"
  license "Apache-2.0"
  head "https:github.comappleswift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a219977d817baf233134e15ec6b13a465b6671a3cfeac1be812acefa58b35e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd3dd707fb54f6cd265a1e044e5719d3f1c4ec2728b89d4af33f1d74ff6e6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "409c1cfb8fb2f4549a6bac2ee8e5ccec476b8bc4f0dd2b3df670ed49f853a58e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd7788839d64da53b4ab0bf823ffc823c9fc591ba42c226b223fa3e01993772"
    sha256 cellar: :any_skip_relocation, ventura:       "626f01ae4645f84d9e3b47ebf5577b38528150963f5ff0228e05013695aaa553"
    sha256                               x86_64_linux:  "4810a1950345b18dae1800f05d4abec4ef9cd760df1a8c892524a942ed44dbdd"
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