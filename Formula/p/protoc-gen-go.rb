class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.7.tar.gz"
  sha256 "f3be1721420f0524ed036e16b5b53f13d10052741a7061db9b13f0a4a469d817"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cbaf4fd942ac517dd5cc4add2ec55762f85e1263231d3b06aa6b831e11a11c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cbaf4fd942ac517dd5cc4add2ec55762f85e1263231d3b06aa6b831e11a11c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cbaf4fd942ac517dd5cc4add2ec55762f85e1263231d3b06aa6b831e11a11c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c3897df45f65149585fba328a759c0363764a43ea56d57dd58317a105920d4a"
    sha256 cellar: :any_skip_relocation, ventura:       "6c3897df45f65149585fba328a759c0363764a43ea56d57dd58317a105920d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f525dc799e32cdcc16ffd479a77142dd08b9672b46877c63dac408e0269fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5597a8d1d9e217d56b6fdf869c858776537ed7fae985743e4fcd4c7c2bbf26be"
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