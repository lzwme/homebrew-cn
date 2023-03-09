class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://ghproxy.com/https://github.com/protocolbuffers/protobuf-go/archive/v1.29.0.tar.gz"
  sha256 "b0ed4f3d61e3783837f119fc89a99eac4415632d4c98d1a0f93d8499023d72fa"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb6b5c800554bc6e9661dfa2bd90643cd9431e1acdff6f115f017dba5e0a123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb6b5c800554bc6e9661dfa2bd90643cd9431e1acdff6f115f017dba5e0a123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb6b5c800554bc6e9661dfa2bd90643cd9431e1acdff6f115f017dba5e0a123"
    sha256 cellar: :any_skip_relocation, ventura:        "1823b6a7ac2a0759a278b73f9e68eea9b58f2c0008ecd43e70946889b83ed330"
    sha256 cellar: :any_skip_relocation, monterey:       "1823b6a7ac2a0759a278b73f9e68eea9b58f2c0008ecd43e70946889b83ed330"
    sha256 cellar: :any_skip_relocation, big_sur:        "1823b6a7ac2a0759a278b73f9e68eea9b58f2c0008ecd43e70946889b83ed330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6e8ddf60d4d62f3d6c23e15ee154d350809b7b972c88ed6c4825d346840559"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
    prefix.install_metafiles
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
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end