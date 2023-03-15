class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://ghproxy.com/https://github.com/protocolbuffers/protobuf-go/archive/v1.29.1.tar.gz"
  sha256 "6ae96be3eebf1bb92a5b9d20cd4082fc32e29e3d7f722c08852ec000a9a637c9"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf85d31836684e112cb55a7210ffeb3df7598705f6c008bff59a20f3f53cabe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf85d31836684e112cb55a7210ffeb3df7598705f6c008bff59a20f3f53cabe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acf85d31836684e112cb55a7210ffeb3df7598705f6c008bff59a20f3f53cabe"
    sha256 cellar: :any_skip_relocation, ventura:        "216416ca128e27bbf6458cd330c56dc0067e27f4580c6773703f03c181616c92"
    sha256 cellar: :any_skip_relocation, monterey:       "216416ca128e27bbf6458cd330c56dc0067e27f4580c6773703f03c181616c92"
    sha256 cellar: :any_skip_relocation, big_sur:        "216416ca128e27bbf6458cd330c56dc0067e27f4580c6773703f03c181616c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d335b3c2d9b1d10c3082b2483bd8fda567b9ee87e767e9537ddb44c6ad51b8"
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