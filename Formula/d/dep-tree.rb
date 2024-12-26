class DepTree < Formula
  desc "Tool for visualizing dependencies between files and enforcing dependency rules"
  homepage "https:github.comgabotechsdep-tree"
  url "https:github.comgabotechsdep-treearchiverefstagsv0.23.1.tar.gz"
  sha256 "cfc88b80c2fdd72f878dac5f364023c9ad7c7a892b0619701b076caf2257b3eb"
  license "MIT"
  head "https:github.comgabotechsdep-tree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef8da46fd543e007f180a4b6acf4fb26e8647712d814bfccadda4e6123d734a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef8da46fd543e007f180a4b6acf4fb26e8647712d814bfccadda4e6123d734a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ef8da46fd543e007f180a4b6acf4fb26e8647712d814bfccadda4e6123d734a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b5ba965fbc433c37a2aeb78875335c88fe9b26fb5aa17227f18bd9059c90fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "8b5ba965fbc433c37a2aeb78875335c88fe9b26fb5aa17227f18bd9059c90fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfb2867b43f338f7c2fc3707c93068db1f5360a640911b4bd3d60dd7612f9d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"foo.js").write <<~JS
      import { bar } from '.bar'
    JS
    (testpath"bar.js").write <<~JS
      export const bar = 'bar'
    JS
    (testpath"package.json").write <<~JSON
      { "name": "foo" }
    JSON
    expected = <<~JSON
      {
        "tree": {
          "foo.js": {
            "bar.js": null
          }
        },
        "circularDependencies": [],
        "errors": {}
      }
    JSON

    assert_equal expected, shell_output("#{bin}dep-tree tree --json #{testpath}foo.js")
  end
end