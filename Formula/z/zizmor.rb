class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://ghfast.top/https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8c0f9ef81c6d5b12d2c85a5ede787c8588ed40100f8e1826251934f18f5e0755"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae421d4c7b94579bbdcb8b02454be00786db7946d1a2961e7b8be0681e2a336a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2115130be7073df9418fbe22eac37c0d8e3a30b87d1581da06f23593c5ff9344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835d56a39b20426265668a34370ac9969d086b85c93543acaaeb3d788b106e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8d8bdddf3dd756a6a6a4ab4e76e305ec42acebd7631acdea70da41d011361b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3641ee62c65412909e4ca9a47d06c1f0337978c6bad9bc7c257a12d9b7cfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcdf25d8941b98e96e5e6d533ef6a98295e87382a0b945f6039f8afc043f68e4"
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