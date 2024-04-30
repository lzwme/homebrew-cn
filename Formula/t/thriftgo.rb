class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https:github.comcloudwegothriftgo"
  url "https:github.comcloudwegothriftgoarchiverefstagsv0.3.11.tar.gz"
  sha256 "3a70495961800318ab384dc42b96f09b2cdfac5d4a42c846d053ea7171dde0cf"
  license "Apache-2.0"
  head "https:github.comcloudwegothriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7910b904a461e07057702cc2a11a6b19e4807844d35fae35f4a9a2ca2292d098"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60245425af21ef47fe9bf4dfae3a80c4eaa405d84b1166293a7b2dd5df18ae67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae990c9773f193cacae1cfdab0cdcf5c2a9ce5d676f4c48fda0c3f1416655de1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b7f90b8d50cbf459b22a1960763053de19d7ebb1c7bff15ef07c630dab829f2"
    sha256 cellar: :any_skip_relocation, ventura:        "6130cedccd2190010928c12b466208b75eb2d63f5031449cc0de2400dcdda19f"
    sha256 cellar: :any_skip_relocation, monterey:       "a5b94c40dabb7d9d70f5f613dd0f2af8f53617095ed3e8a540b19aea352f4619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c770b984e2846ca8702db880b7f76c2061c339b82040c55c72f86406b7d355e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

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
    system "#{bin}thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath"api""test.go", :exist?
    refute_predicate (testpath"api""test.go").size, :zero?
  end
end