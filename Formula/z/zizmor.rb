class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "a3d3a062ffd79f3958c7d428a9aeb8b6332d57bc3fb15bed242d519aa11e2f42"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b34a44f694872a7e7bea9494acc09bf7710ef951fc5072ae6d0dea8f87a32bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca1dfe5991c973c57c37cb0ae70ce5a3d3535c105c0ef31ac789aef64bab72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251c9d5092c7e13602521f59dd34c01b3e9d885a5da7a71399d93a2d684cf83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4869fd66187bc3216323acde184ed7cfb65058a7876c68763f466afa7578e0df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553ad44a5c02c03055ebf93b78d5e49adf16693b93fdefe8baa18f594d489138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a1ab2d6e78b19581c4c76f854298e4b665753142587f2670ce7349305df928"
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