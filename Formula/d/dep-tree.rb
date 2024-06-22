class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.22.0.tar.gz"
  sha256 "a702355ec8b6c5970084a558312bcb648461730f0ebdefb8728735b41a79b052"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5cd727c44c8a38b35c88296ce4fcc60de5b18b765a288c2a77708b4e033dec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "992de1c95457e36f78759ee49035bf3a950b21089b1a9f1860fe8806de92bfc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15bbe34a72950109208aad724fe98f3f8dd195b23dc4265b9fb4803423383c9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ab76c28f9d5ff0da33b50c890a3f9d02fa68ecf05ed96ddf65a85dddb1dfc3b"
    sha256 cellar: :any_skip_relocation, ventura:        "cd4b03deaf235111e53ab8476f5a8655783c8c0d5fb320528f9ff0a3d9570204"
    sha256 cellar: :any_skip_relocation, monterey:       "ac9ff06c2ff04dc03bfd8da69dcd98f71c3a1df58b3a4314850857389e06fcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1156cc5e678b1b18701800680ecae4239d1cf1a469cb73e8035885834538e0c"
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