class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https:github.comtmccombshcl2json"
  url "https:github.comtmccombshcl2jsonarchiverefstagsv0.6.6.tar.gz"
  sha256 "5dd497f852e4c00b2e80c9f327b5650446d7eb794f8671563f39748dc847b9ba"
  license "Apache-2.0"
  head "https:github.comtmccombshcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27f21fb355a56ebd9c4784bc4504552688914c115700db28fc27e367559b5e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27f21fb355a56ebd9c4784bc4504552688914c115700db28fc27e367559b5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e27f21fb355a56ebd9c4784bc4504552688914c115700db28fc27e367559b5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c268c918f1d3697a839b6b4beb1514f9870a1d49d8576186791bbb97b41df2"
    sha256 cellar: :any_skip_relocation, ventura:       "e3c268c918f1d3697a839b6b4beb1514f9870a1d49d8576186791bbb97b41df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18de64ea83b3b25b19bf06414bf7220a23e76530f539cc696c0dd6686f4183c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_hcl = testpath"test.hcl"
    test_hcl.write <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL

    test_json = {
      resource: {
        my_resource_type: {
          test_resource: [
            {
              input: "magic_test_value",
            },
          ],
        },
      },
    }.to_json

    assert_equal test_json, shell_output("#{bin}hcl2json #{test_hcl}").gsub(\s+, "")
    assert_match "Failed to open brewtest", shell_output("#{bin}hcl2json brewtest 2>&1", 1)
  end
end