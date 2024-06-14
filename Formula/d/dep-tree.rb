class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.20.7.tar.gz"
  sha256 "a89ac0975b01cfb4785090b0a28ea822079523a407c958fb4eb0703e326a3f12"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6d57e6bddab7a9acd4d46739f4989b1586079e98685a5b7e0a422d1056946de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7995a0a21600225e43f8f7b449ab7571cb4f7d115b4bf6d405a947fb97d86a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900b14ba84e3c158c14e6e684a468d10c2a0d713bf75e1fb2b786ecb6e66c65a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e90ce38efe8183961fd4553cafbd506639bcc29950fc21d85fab48464ed876f2"
    sha256 cellar: :any_skip_relocation, ventura:        "f9bed8e9e429ff785ee9ab2e878c32d7773812af4d9f5bb0a7166789768e44fa"
    sha256 cellar: :any_skip_relocation, monterey:       "82b2454f7b3074294004d527e36e58fc0e14d977e28f983327248a0dbe17b4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff81f11ce21ebcb2a0673b0d01219d25162ea18a38c756c7d1507d2ac1cf5e2"
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