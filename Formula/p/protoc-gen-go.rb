class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https:github.comprotocolbuffersprotobuf-go"
  url "https:github.comprotocolbuffersprotobuf-goarchiverefstagsv1.36.1.tar.gz"
  sha256 "28a6c9eb62a06e65e866bcdb2005c63f9ee7b57c271617ed761f309c7ece17fb"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094e934d70c382bf27e5b6577fa1a6412d9275e612f51043b873f74771c25767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094e934d70c382bf27e5b6577fa1a6412d9275e612f51043b873f74771c25767"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "094e934d70c382bf27e5b6577fa1a6412d9275e612f51043b873f74771c25767"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0773daaaf8376e836d696bd292d2fc4d2e64cb572861233c44bf7303500aa1"
    sha256 cellar: :any_skip_relocation, ventura:       "3b0773daaaf8376e836d696bd292d2fc4d2e64cb572861233c44bf7303500aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee8a627a55dcba33fc3f5c267beca0ef417b96cbdec8f781e05e520964fe16b"
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