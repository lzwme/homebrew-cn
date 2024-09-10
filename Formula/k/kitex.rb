class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.11.0.tar.gz"
  sha256 "6846e80ca4ec3f601184da3f450c91f2e69199ab7c915a35ad7c2bec46c78ccf"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f67c1da549bd0909c666f658467850e58e05de7d1f3525fc9d01bf77687e648"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f67c1da549bd0909c666f658467850e58e05de7d1f3525fc9d01bf77687e648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f67c1da549bd0909c666f658467850e58e05de7d1f3525fc9d01bf77687e648"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a8491aa0eebb0033a461958e81306c54342a1e849435f242a1570fc260ac267"
    sha256 cellar: :any_skip_relocation, ventura:        "5a8491aa0eebb0033a461958e81306c54342a1e849435f242a1570fc260ac267"
    sha256 cellar: :any_skip_relocation, monterey:       "5a8491aa0eebb0033a461958e81306c54342a1e849435f242a1570fc260ac267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e45a06a58d057f8e88a3c79ea90849864ae3749289cc9a6790bafc8490438b"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".toolcmdkitex"
  end

  test do
    output = shell_output("#{bin}kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath"test.thrift"
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
    system bin"kitex", "-module", "test", "test.thrift"
    assert_predicate testpath"go.mod", :exist?
    refute_predicate (testpath"go.mod").size, :zero?
    assert_predicate testpath"kitex_gen""api""test.go", :exist?
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end