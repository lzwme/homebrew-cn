class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https:github.comprotocolbuffersprotobuf-go"
  url "https:github.comprotocolbuffersprotobuf-goarchiverefstagsv1.32.0.tar.gz"
  sha256 "816e0babc183807928c4ede81999dc1e33bfe6e7eca9ccebe0409974e68559db"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c9eec20dbdf35acd4c23d597ed0a6acaa3225b9fee6481d1e5139e4bf0cc4ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c9eec20dbdf35acd4c23d597ed0a6acaa3225b9fee6481d1e5139e4bf0cc4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c9eec20dbdf35acd4c23d597ed0a6acaa3225b9fee6481d1e5139e4bf0cc4ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "87763d7d3a6756eeeba5df837a74a70d29de0d41019f986d0e9a9d13e058482a"
    sha256 cellar: :any_skip_relocation, ventura:        "87763d7d3a6756eeeba5df837a74a70d29de0d41019f986d0e9a9d13e058482a"
    sha256 cellar: :any_skip_relocation, monterey:       "87763d7d3a6756eeeba5df837a74a70d29de0d41019f986d0e9a9d13e058482a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48bb325b0d4ce1caadbe2ff17598c5286471e6b5bd5c24304c110318b2847ace"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdprotoc-gen-go"
    prefix.install_metafiles
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