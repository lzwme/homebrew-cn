class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.22.4.tar.gz"
  sha256 "4dbfd69528113ae787f95c526b0b00a3b726ce06c6fa585f5ef087b6b8056c54"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e9091f27ae6049f3cc2dd9480125dc79750ef9d3121db8a034fde545b8dd057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41830de68d7820cf0cdac780404d02f2e81dce6a3c873c5d55ac2f76ff6f1b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc479761a7c688f42f667a280b4efe7e0eeab41417f69afba4035e384a76461"
    sha256 cellar: :any_skip_relocation, sonoma:         "138a50450b472852084733a5987a2fc72d2c9d86f826185c65b72cfc061dc41a"
    sha256 cellar: :any_skip_relocation, ventura:        "89947af9db27140299c9595eee7ff52047594b88473de27ded7dbdb404d577fb"
    sha256 cellar: :any_skip_relocation, monterey:       "2da852b65bd7b79276e693fb4a695a7ba24d6195224574ddfc344e0b095d47e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7c3c6018917eff9b4ec99753b0f394ac1c995752b0e64d473940e086b4808b"
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