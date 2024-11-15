class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https:github.comprotocolbuffersprotobuf-go"
  url "https:github.comprotocolbuffersprotobuf-goarchiverefstagsv1.35.2.tar.gz"
  sha256 "46c472e0ce2f68a50134152d99e8ca8d9b8b627b85ce4181f07e4ab7557e46e2"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dfde25c3cf7d95e4018494a5c4098a653eddb0b03dc03e3a383635480643274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dfde25c3cf7d95e4018494a5c4098a653eddb0b03dc03e3a383635480643274"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dfde25c3cf7d95e4018494a5c4098a653eddb0b03dc03e3a383635480643274"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6205261731bd90998d3e41c34956df2a3411e9734e03c46e220c6b255d7085e"
    sha256 cellar: :any_skip_relocation, ventura:       "b6205261731bd90998d3e41c34956df2a3411e9734e03c46e220c6b255d7085e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab6552c04aa0020220bea4e6514956980359c795f141b8460086184cf2c5f79"
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