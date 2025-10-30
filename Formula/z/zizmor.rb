class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "14632d8cd7955aa075bf4198aa84c92e357174495a12ccbae27e362a5a2f3f1e"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab68d51d1b792173da733a5e0014c29403f6a8b6f66db104da278eac7181bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d34a5ab47e712ea4ceaadc6d703773943a5e19381d7f1dfdd79efb09b9ae73c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88d35a6b07ba3425a592c11ad07c1ded2dd67ab38837916664dbc671b268227"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eaec1f170aded1a1eab3fbb7c353253ee71c2538644d4b3f06f1d4e29f68a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aec18ce54159106548063fd12a4bf2670e5d504281f3abb5fb253693728f896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6edb74c2dc3e446040759bd401945e0f1a48263a497f32f00ecd1471146746c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end