class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghfast.top/https://github.com/cloudwego/kitex/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "976f196913ac18c06749249cc3eaf1710f9696a08b215f1d42e42aac81599a4e"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daac15d69d3cdd1c40b50ececfa1a6be8558c09518c1dc404415c6cbcbdb14bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daac15d69d3cdd1c40b50ececfa1a6be8558c09518c1dc404415c6cbcbdb14bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daac15d69d3cdd1c40b50ececfa1a6be8558c09518c1dc404415c6cbcbdb14bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f14a83647f37da7b727e66512c2f7fc26770b1d33e2c1a4d271824aafa4a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee0657fd1daf1427aa1a05814f5a97e009e82b339e7763354c6768d24f0b633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "147ed865ff94cf797c1ce2dd4277458fb216d2383357d6e7bb6a2be32ba3873b"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tool/cmd/kitex"
  end

  test do
    output = shell_output("#{bin}/kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system bin/"kitex", "-module", "test", "test.thrift"
    assert_path_exists testpath/"go.mod"
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_path_exists testpath/"kitex_gen/api/test.go"
    refute_predicate (testpath/"kitex_gen/api/test.go").size, :zero?
  end
end