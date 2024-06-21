class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.21.3.tar.gz"
  sha256 "a6a724530b26a0d3e0f82ed0b4e4b8d105c266721b9dfd76410a8fe62945fca5"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a4371a004d291fb2d2626f33d8ae7eb2367120244ce6786f2b873446397e264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb803a8b0948433121aa0d0a7a2a76dd14ff15ae6936c724174ea4bcd0db9fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81aaa3ede1f63224389f75e7f97ba43baf71e036cd4f9367aecc20d703b06e8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4e0203c09d6e263636f868d6bf1b0ac30ce2feb9e078829cd3ef3a7ea7ec9e9"
    sha256 cellar: :any_skip_relocation, ventura:        "919a03263db2a7f5fde5afe7877ccc91f7668dce69394374163be1ffe9a8ed1e"
    sha256 cellar: :any_skip_relocation, monterey:       "d032362ac03be90567c5053f8d4356e17d75af637167bf0e7f54bbe1fb77bc98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe360f33bbf21001967e77fa86327ed365424be88782614ca0bf87faeddbdd1"
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