class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https:github.comappleswift-protobuf"
  url "https:github.comappleswift-protobufarchiverefstags1.27.0.tar.gz"
  sha256 "387ab60f4814e76ed3ae689690c658cf6dab1bc1c6ed67d6c14c33de9daed4d2"
  license "Apache-2.0"
  head "https:github.comappleswift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263fd3d48287f507d1c942be9927be6ae17fe7626c84e54fabdb6288dfe325f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f9bb88c2280b624fc2e173f22c9d597469896779ca5eb101a7c1decee64f9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f8874cb155e2f36aea49ed8d2c2ae701f65c1b92b886ca8388a2ed7c377908"
    sha256 cellar: :any_skip_relocation, ventura:       "74614c199b907b243b1cd70d2cea50cd1dbf23bcb8853ba80deaabc7c983d6d9"
    sha256                               x86_64_linux:  "67c7b9be03a5c1161b8b16c641f5e74e3efbdf46aa53b60ad4b951dd0eac84a2"
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