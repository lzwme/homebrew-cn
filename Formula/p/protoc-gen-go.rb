class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https:github.comprotocolbuffersprotobuf-go"
  url "https:github.comprotocolbuffersprotobuf-goarchiverefstagsv1.36.2.tar.gz"
  sha256 "360ccbd38d9ad429535847bdddb57827b599fcd67f1bd03dd26a28103e87cf91"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efe8f827359c650b4e02dfedcefbfcbda9439698e781ee4e555a778944c9f27e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efe8f827359c650b4e02dfedcefbfcbda9439698e781ee4e555a778944c9f27e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efe8f827359c650b4e02dfedcefbfcbda9439698e781ee4e555a778944c9f27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "85697bd02d2b6baaacf2fb8136ec138e79559c4035215d34f96ac4efe3e1afd0"
    sha256 cellar: :any_skip_relocation, ventura:       "85697bd02d2b6baaacf2fb8136ec138e79559c4035215d34f96ac4efe3e1afd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468bf299ca7f613da3b93255675d5540b536d2b6079111f92cb1ea027d69d722"
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