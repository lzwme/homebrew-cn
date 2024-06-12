class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:dep-tree-explorer.vercel.app"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.20.4.tar.gz"
  sha256 "961801bcf8cdabd59d8b2be1a175d2689e308202329967a71b8b2c890a6ab978"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f92a494aa6ba89315ebb91b49b03ca374e8cb2ef62977253ddf74e965c9a97f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36e5e1c5df6c7e4f1121942058f07fe1a29098f4e995135ceb86841cd320b952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa36cdf0eb34f6564a1e1bf5d0a5ecf73868eb0ae0657c0f2aff40ecb391700"
    sha256 cellar: :any_skip_relocation, sonoma:         "c38fefbe8a3be3694a66c846d694fe11d1bc822ebdaeb40407e0b64421e830a3"
    sha256 cellar: :any_skip_relocation, ventura:        "866afd34ab3861eb72e69a902729310dec3ee2c658492af46473312a26638e98"
    sha256 cellar: :any_skip_relocation, monterey:       "85d3c5b8d7fd64b123e662a0941f903f7196e3e5624cc9624384eed8efe9ecf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cec1280cb882a20d4e71960a47b0c8ebb7b0e36792c4662e2cbdeeec538175"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    foo_test_file = testpath"foo.js"
    foo_test_file.write "import { bar } from '.bar'"

    bar_test_file = testpath"bar.js"
    bar_test_file.write "export const bar = 'bar'"

    package_json_file = testpath"package.json"
    package_json_file.write "{ \"name\": \"foo\" }"

    result_file = testpath"out.json"
    output = shell_output("#{bin}dep-tree tree --json #{foo_test_file}")
    result_file.write(output)

    expected = <<~EOF
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    EOF
    assert_equal expected, result_file.read
  end
end