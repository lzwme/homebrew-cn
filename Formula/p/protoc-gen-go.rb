class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.8.tar.gz"
  sha256 "2f3dda9249a392089bb21271a7ae71c114373f18952e644c7fb92681c8dc0018"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cfa580aeee4527291728a4872084b5abfd8a1ac6c9cdc18422a2a1450f1a025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cfa580aeee4527291728a4872084b5abfd8a1ac6c9cdc18422a2a1450f1a025"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cfa580aeee4527291728a4872084b5abfd8a1ac6c9cdc18422a2a1450f1a025"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4977de2386ffcbcbd2ac7ef61ae4abfd2e3917672804cb41ff1b56cb31a68e"
    sha256 cellar: :any_skip_relocation, ventura:       "0e4977de2386ffcbcbd2ac7ef61ae4abfd2e3917672804cb41ff1b56cb31a68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce7baf1b8797099ee574db8ab482316cd1c8957f191c7c96fc00bd83e0d686d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d32babe8d7e0f9c0f9bd13d530bcdebb3be10e1dff9252abc79798f5b9673f"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end