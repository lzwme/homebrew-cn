class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.22.3.tar.gz"
  sha256 "c314c3ad53f5e1aadc76c15a4e2d66200ee048258e59a46010d1191203a4fb97"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "450a6e3f0ff09fe179ecb00ad38d24f1a2207c157a4adec244cfece9b8317b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b7c4a8ea8abc1abd3958c68d31ba09321794f71f81004f574401dc5dcef17c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb19d4b635b75833a149aa29a61edb7f01ac4f62e1549d7f2881e5bc96a6d39"
    sha256 cellar: :any_skip_relocation, sonoma:         "78c9d29b3701392853cd3a00cd934b45a6fea001df13c96f7398c88a5b7418be"
    sha256 cellar: :any_skip_relocation, ventura:        "f729bd53a5c7b634bc9aa9700d29daa74d199e05f9510f3910f91407ed6675bf"
    sha256 cellar: :any_skip_relocation, monterey:       "51b58c85dfee7c7a22d52fbb4770a891e0b826d907cdf0d045d1d40a05ff5bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad36c014ef8846382870741f5073ad53ec1ad55b554a84221b35e950da18823"
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