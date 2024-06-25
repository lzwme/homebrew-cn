class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.10.1.tar.gz"
  sha256 "61ab41f696e506df93b5df0ca92df38b41fb18831ecaaee625a219aa4b052eef"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26b158cfa53b164beef7b8b16589644234050d9b1da99c82c84864ef3467d5ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7351438d84d9e1c1651623868da799225dafa22fc404e75fbb047b41fcbac89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92962f51fcdfe15ad5e372b286cadc3d9875d348860815483c4989b48d4b3bc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3818c3e811adc831bd448a03005b2972fb56a06037be545448b49d8f8a7659"
    sha256 cellar: :any_skip_relocation, ventura:        "5d01dd568c90e008d7bf065ea57847a74d198c3bf9e18375409d43129f1cf20c"
    sha256 cellar: :any_skip_relocation, monterey:       "f819c705d5638aacfa61684b07ad19a26d1edf2b8233162bb0351433e8fe20d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b133c52579fd2c9325e22448937634851e90fd781e40c846d63424747be47d4"
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
    system "#{bin}kitex", "-module", "test", "test.thrift"
    assert_predicate testpath"go.mod", :exist?
    refute_predicate (testpath"go.mod").size, :zero?
    assert_predicate testpath"kitex_gen""api""test.go", :exist?
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end