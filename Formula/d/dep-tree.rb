class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.21.2.tar.gz"
  sha256 "7698be6e7d1fb30731a430bfc4c43181984725e372eadd9b5f43fba66cd8bb82"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef4b6f174b71276854ef853fcce7b6f216365fbfa4f389ef9f330ed7ae0a8167"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07e074436532bd97f62fff7e7d068f5e5f638997e51ecad9cdffdbde214304ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18636324442d4cf19bc7e064390e5971eb4d57333151abce0a03adcde5e253e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "636e4392eff130b631684f820f802857284ce66b3eaead06d1b449d8cb1a6539"
    sha256 cellar: :any_skip_relocation, ventura:        "852b751477267ef8cbb13be6f938ac01d4fc8d12046f2f51ecf5d9885dee3771"
    sha256 cellar: :any_skip_relocation, monterey:       "16240dc96bb32313a342390c9bd2830457d1c2e47f95a9667425192a0b06f0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c083d1978f431aab380b5fa75e154ebd2232d405f31f228c2e9cda4946c937c"
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