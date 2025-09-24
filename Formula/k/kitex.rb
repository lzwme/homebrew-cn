class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghfast.top/https://github.com/cloudwego/kitex/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "2aa427b636048c107b07336f6cc6f6d8f1db338bb6ecce96f3db4f4b982d4064"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6e190007b39423f30a4d1b7ab612eee546c3c3559f7001df7c85b217ec4f56e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e190007b39423f30a4d1b7ab612eee546c3c3559f7001df7c85b217ec4f56e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e190007b39423f30a4d1b7ab612eee546c3c3559f7001df7c85b217ec4f56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "834fa104766b9cac3f9d16347997e91afc16149681dc500808939d7fd682e80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ae279b4eca2c315f3b40c4056165245cee8b331ea6df4f542dfbed25d15753"
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
    assert_path_exists testpath/"kitex_gen"/"api"/"test.go"
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end