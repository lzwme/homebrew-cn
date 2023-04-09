class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://ghproxy.com/https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8a5c2d70b0836985d7ad39e7e00a804b7ec76a09503374fee41113b82977cb83"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c3d4aecbeacdf5e70458f50cb2423ecfa60a69eeb5443b2d4d236a0a7f6b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c3d4aecbeacdf5e70458f50cb2423ecfa60a69eeb5443b2d4d236a0a7f6b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c3d4aecbeacdf5e70458f50cb2423ecfa60a69eeb5443b2d4d236a0a7f6b49"
    sha256 cellar: :any_skip_relocation, ventura:        "13cc304c6f4ebcb2978f433583b6234b4da6e3b2444d658b5608d3e9a6f0775b"
    sha256 cellar: :any_skip_relocation, monterey:       "13cc304c6f4ebcb2978f433583b6234b4da6e3b2444d658b5608d3e9a6f0775b"
    sha256 cellar: :any_skip_relocation, big_sur:        "13cc304c6f4ebcb2978f433583b6234b4da6e3b2444d658b5608d3e9a6f0775b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cbef468ebff03271b020468a5fe696bb2dab10e94665bad0f4254fa512181c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

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
    system "#{bin}/thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end