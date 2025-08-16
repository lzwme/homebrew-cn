class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "1caa4b9884d7755cd5679f629ecbfe7d028cbb508fae9ed423129b48f7f3dbaf"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b165ab9a0632a384b65d116c300f345ec0adde8aafbaa11153cfd53f998bbbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f6ffb0cb2684987c0adfb39d3526094b69352d2e506b907c9cb087f345d83e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddb50e002a7427a535dedbb43e993b7e5d6f4ce5f149d97266a7721440ad3f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f252094098ce2aa1ad2aeeec7a829f07e553bc925ce3f02df2189244151a249"
    sha256 cellar: :any_skip_relocation, ventura:       "1247d3e6f79e5418fe47eb6a6504b40b57efc1e1d726e9609d90d22cfa395d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "999c21c0136e75d0252f76cd5eea3854f42f2c58b8e6ea33f489a6a1e2541efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74e3f90aebd8a41e0b958010af622566c9bc66c33bac8aa4a0d00715e41d971"
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