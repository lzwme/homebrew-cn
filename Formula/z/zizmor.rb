class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "c9be8ca32ce657a692aab12b524e63b77c9d146058a4465ee9cf980da5a4cbe6"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "226fe3bacec12015da3c4e7126f6f51775613f405e83553958d43680c2e516e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41e220f11a43d00b9a1b6e8ac0e2cd3ebbe0bf0787180729ce804d95f36aee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb99fad8efaf68aaabcdd4c2904e65913b14d28b7a20076dd9e70e15e26462fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "69870c40043cc53e3a38af06ef46420542781f97aa623e1d4d3c53c4b65d4ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcccaf11bfdfc999da07fe8869b3d8d1e51fb786883d4ff56954c8b4402aa866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c48009553bc28f5ce6ec3bdaba32db2d56800741b3b1bbcfab3c4f420537a1d"
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