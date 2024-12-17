class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https:github.comprotocolbuffersprotobuf-go"
  url "https:github.comprotocolbuffersprotobuf-goarchiverefstagsv1.36.0.tar.gz"
  sha256 "722b740046aa6711403edb5349503ca19d77a587b1192f3781821379a2335938"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95bb8983c8809c51bbaab47ef8118977fe21f68a2f241b2a7d122dc65c039d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95bb8983c8809c51bbaab47ef8118977fe21f68a2f241b2a7d122dc65c039d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95bb8983c8809c51bbaab47ef8118977fe21f68a2f241b2a7d122dc65c039d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf0e74d938de795b4c4f1f6345abc927c7d5f92443213858bd3f1e2220ddf31"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf0e74d938de795b4c4f1f6345abc927c7d5f92443213858bd3f1e2220ddf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f02b66566e0e34d8c9851a688aaea2d80e40f8cb0a0fdbfc4985f989964a020"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdprotoc-gen-go"
  end

  test do
    protofile = testpath"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "packagetest";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath"proto3.pb.go", :exist?
    refute_predicate (testpath"proto3.pb.go").size, :zero?
  end
end